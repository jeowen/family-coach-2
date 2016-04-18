//
//  PTSDatastore.h
//  PTSD Coach
//

@class MPMediaItem;
@class PTSAssessment;
@class PTSReminderManager;
@class PTSRIDSession;

#import <Foundation/Foundation.h>

@interface PTSDatastore : NSObject<NSCoding>

// Public Properties
@property(nonatomic, strong, nullable) NSArray<PTSAssessment *> *assessments;
@property(nonatomic, strong, nullable) NSArray<PTSRIDSession *> *RIDSessions;
@property(nonatomic, strong, nullable) NSArray<UIImage *> *mindfulPhotos;
@property(nonatomic, strong, nullable) NSArray<MPMediaItem *> *mindfulSongs;
@property(nonatomic, strong, nullable) NSArray<UIImage *> *soothingPhotos;
@property(nonatomic, strong, nullable) NSArray<MPMediaItem *> *soothingSongs;
@property(nonatomic, strong, nullable) NSArray<id> *supportContacts;

@property(nonatomic, strong, nullable) NSArray<PTSAssessment *> *fakeAssessments;

@property(nonatomic, assign, getter = hasShownPreflightScreens) BOOL shownPreflightScreens;
@property(nonatomic, assign, getter = isAnalyticsTrackingEnabled) BOOL analyticsTrackingEnabled;

@property(nonatomic, strong, readonly, nonnull) PTSReminderManager *reminderManager;

// Class Methods
+ (nonnull instancetype)sharedDatastore;

// Public Methods
- (void)save;
- (void)clearAllUserData;
- (void)clearToolPreferences;

@end
