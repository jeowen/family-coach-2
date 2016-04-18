//
//  PTSDatastore.m
//  PTSD Coach
//

@import Contacts;
@import ContactsUI;
@import MediaPlayer;

#import "PTSDatastore.h"
#import "PTSAssessment.h"
#import "PTSReminderManager.h"
#import "PTSRIDSession.h"
#import "NSDate+PTSDate.h"

static NSString *const PTSDatastoreUserDefaultsKey = @"PTSDatastore";

#pragma mark - Private Interface

@interface PTSDatastore()

@end

#pragma mark - Implementation

@implementation PTSDatastore

#pragma mark - Class Methods

/**
 *  sharedDatastore
 */
+ (instancetype)sharedDatastore {
  static PTSDatastore *sSharedDatastore;
  static dispatch_once_t sharedDatastoreOnceToken;
  
  dispatch_once(&sharedDatastoreOnceToken, ^{
    // Look for an existing datastore within the user defaults.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:PTSDatastoreUserDefaultsKey];
    
    if (encodedObject) {
      sSharedDatastore = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    
    // Create a new one if there was an error decoding.
    if (!sSharedDatastore) {
      sSharedDatastore = [[PTSDatastore alloc] init];
    }
  });
  
  return sSharedDatastore;
}

#pragma mark - Lifecycle

/**
 *   init
 */
- (instancetype)init {
  self = [super init];
  if (self) {
    _analyticsTrackingEnabled = NO;
    _shownPreflightScreens = NO;
    _reminderManager = [[PTSReminderManager alloc] init];
  }
  
  return self;
}

/**
 *  initWithCoder
 */
- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [self init];
  if (self) {
    _analyticsTrackingEnabled = [coder decodeBoolForKey:@"analyticsTrackingEnabled"];
    _shownPreflightScreens = [coder decodeBoolForKey:@"shownPreflightScreens"];
    
    _assessments = [coder decodeObjectForKey:@"assessments"];
    _reminderManager = [coder decodeObjectForKey:@"reminderManager"];
    _RIDSessions = [coder decodeObjectForKey:@"RIDSessions"];
    
    _mindfulSongs = [self mediaItemsFromPersistentIdentifiers:[coder decodeObjectForKey:@"mindfulSongs"]];
    _soothingSongs = [self mediaItemsFromPersistentIdentifiers:[coder decodeObjectForKey:@"soothingSongs"]];
    _supportContacts = [self contactsFromContactIdentifiers:[coder decodeObjectForKey:@"supportContacts"]];
    
    // We require a reminder manager to be present
    if (!_reminderManager) {
      _reminderManager = [[PTSReminderManager alloc] init];
    }
  }
  
  return self;
}

/**
 *  encodeWithCoder
 */
- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeBool:self.isAnalyticsTrackingEnabled forKey:@"analyticsTrackingEnabled"];
  [coder encodeBool:self.hasShownPreflightScreens forKey:@"shownPreflightScreens"];

  [coder encodeObject:self.assessments forKey:@"assessments"];
  [coder encodeObject:self.reminderManager forKey:@"reminderManager"];
  [coder encodeObject:self.RIDSessions forKey:@"RIDSessions"];
  
  [coder encodeObject:[self persistentIdentifiersFromMediaItems:self.mindfulSongs] forKey:@"mindfulSongs"];
  [coder encodeObject:[self persistentIdentifiersFromMediaItems:self.soothingSongs] forKey:@"soothingSongs"];
  [coder encodeObject:[self contactIdentifiersFromContacts:self.supportContacts] forKey:@"supportContacts"];
}

#pragma mark - Public Methods

/**
 *  fakeAssessments
 */
- (NSArray<PTSAssessment *> *)fakeAssessments {
  if (!_fakeAssessments) {
    NSMutableArray *mutableFakeAssessments = [[NSMutableArray alloc] init];
    
    for (NSUInteger count = 0; count < 20; count++) {
      PTSAssessment *fake = [[PTSAssessment alloc] init];
      fake.date = [NSDate generateRandomDateWithinDaysBeforeToday:30];
      fake.score = arc4random_uniform(80);
      
      [mutableFakeAssessments addObject:fake];
    }
    
    _fakeAssessments = [mutableFakeAssessments copy];
  }
  
  return _fakeAssessments;
}

/**
 *  save
 */
- (void)save {
  NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  [userDefaults setObject:encodedObject forKey:PTSDatastoreUserDefaultsKey];
  [userDefaults synchronize];
}

/**
 *  clearToolPreferences
 */
- (void)clearToolPreferences {
  
}

/**
 *  clearAllUserData
 */
- (void)clearAllUserData {
  self.mindfulPhotos = nil;
  self.mindfulSongs = nil;
  self.soothingPhotos = nil;
  self.soothingSongs = nil;
  self.supportContacts = nil;
  
  self.analyticsTrackingEnabled = NO;
  self.shownPreflightScreens = NO;
  
  self.assessments = nil;
  self.RIDSessions = nil;
  
  [self save];
}

#pragma mark - Private Methods

/**
 * persistentIdentifiersFromMediaItems
 */
- (NSArray *)persistentIdentifiersFromMediaItems:(NSArray *)mediaItems {
  NSMutableArray *mutablePersistentIdentifiers = [[NSMutableArray alloc] initWithCapacity:mediaItems.count];
  
  for (MPMediaItem *mediaItem in mediaItems) {
    [mutablePersistentIdentifiers addObject:[mediaItem valueForProperty:MPMediaItemPropertyPersistentID]];
  }
  
  return [mutablePersistentIdentifiers copy];
}

/**
 *  mediaItemsFromPersistentIdentifiers
 */
- (NSArray *)mediaItemsFromPersistentIdentifiers:(NSArray *)persistentIdentifiers {
  NSMutableArray *mutableMediaItems = [[NSMutableArray alloc] initWithCapacity:persistentIdentifiers.count];
  
  for (NSNumber *persistentIdentifier in persistentIdentifiers) {
    MPMediaQuery *songQuery = [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:persistentIdentifier
                                                                           forProperty:MPMediaItemPropertyPersistentID];
    
    [songQuery addFilterPredicate: predicate];
    
    if (songQuery.items.count > 0) {
      [mutableMediaItems addObject:songQuery.items.firstObject];
    }
  }
  
  return [mutableMediaItems copy];
}

/**
 *  contactIdentifiersFromContacts
 */
- (NSArray *)contactIdentifiersFromContacts:(NSArray *)contacts {
  NSMutableArray *mutableContactIdentifiers = [[NSMutableArray alloc] initWithCapacity:contacts.count];
  
  for (CNContact *contact in contacts) {
    [mutableContactIdentifiers addObject:contact.identifier];
  }
  
  return [mutableContactIdentifiers copy];
}

/**
 *  contactsFromContactIdentifiers
 */
- (NSArray *)contactsFromContactIdentifiers:(NSArray *)contactIdentifiers {
  NSMutableArray *mutableContacts = [[NSMutableArray alloc] initWithCapacity:contactIdentifiers.count];
  CNContactStore *contactStore = [[CNContactStore alloc] init];
  
  for (NSString *contactIdentifier in contactIdentifiers) {
    CNContact *contact = [contactStore unifiedContactWithIdentifier:contactIdentifier
                                                        keysToFetch:@[[CNContactViewController descriptorForRequiredKeys]]
                                                              error:nil];
    
    if (contact) {
      [mutableContacts addObject:contact];
    }
  }

  return [mutableContacts copy];
}

#pragma mark - Debugging Methods

/**
 *  debugDescription
 */
- (NSString *)debugDescription {
  NSMutableArray *mutableParts = [[NSMutableArray alloc] init];
  [mutableParts addObject:@""];
  
  void (^outputMediaItems)(NSArray *) = ^(NSArray *mediaItems) {
    for (MPMediaItem *mediaItem in mediaItems) {
      NSNumber *persistentIdentifier = [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
      [mutableParts addObject:persistentIdentifier];
    }
  };
  
  void (^outputContacts)(NSArray *) = ^(NSArray *contacts) {
    for (CNContact *contact in contacts) {
      [mutableParts addObject:contact.identifier];
    }
  };

  void (^outputAssessments)(NSArray *) = ^(NSArray *assessments) {
    for (PTSAssessment *assessment in assessments) {
      [mutableParts addObject:[NSString stringWithFormat:@"Date:%@ - Score:%@", assessment.date, @(assessment.score)]];
    }
  };
  
  // Analytics
  [mutableParts addObject:[NSString stringWithFormat:@"Analytics Tracking Enabled: %@", @(self.isAnalyticsTrackingEnabled)]];
  
  // Preflight
  [mutableParts addObject:[NSString stringWithFormat:@"Has Shown Prefight Screens: %@", @(self.hasShownPreflightScreens)]];
  
  // Assessments
  [mutableParts addObject:[NSString stringWithFormat:@"Assessments (%@)", @(self.assessments.count)]];
  outputAssessments(self.assessments);
  
  // Mindful Songs
  [mutableParts addObject:[NSString stringWithFormat:@"Mindful Songs (%@)", @(self.mindfulSongs.count)]];
  outputMediaItems(self.mindfulSongs);
  
  // Soothing Songs
  [mutableParts addObject:[NSString stringWithFormat:@"Soothing Songs (%@)", @(self.soothingSongs.count)]];
  outputMediaItems(self.soothingSongs);

  // Support Contacts
  [mutableParts addObject:[NSString stringWithFormat:@"Support Contacts (%@)", @(self.supportContacts.count)]];
  outputContacts(self.supportContacts);
  
  return [mutableParts componentsJoinedByString:@"\n"];
}

@end
