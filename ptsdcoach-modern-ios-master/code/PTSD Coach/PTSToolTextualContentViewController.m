//
//  PTSToolTextualContentViewController.m
//  PTSD Coach
//

#import "PTSToolTextualContentViewController.h"
#import "PTSRandomContentProvider.h"
#import "PTSSymptom.h"
#import "PTSTherapySession.h"
#import "PTSTool.h"

#pragma mark - Private Interface

@interface PTSToolTextualContentViewController()

@property(nonatomic, weak) IBOutlet UILabel *headerLabel;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *contentLabel;
@property(nonatomic, weak) IBOutlet UILabel *footerLabel;

@property(nonatomic, strong) PTSRandomContentProvider *randomContentProvider;

@end

#pragma mark - Implementation

@implementation PTSToolTextualContentViewController

#pragma mark - UIViewController

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self prepareViewForDisplay];
  [self refreshToolIfPossible];
}

#pragma mark - PTSToolViewDelegate Methods

/**
 *  wantsToolRefreshButtonInToolbar
 */
- (BOOL)wantsToolRefreshButtonInToolbar {
  return YES;
}

/**
 *  refreshToolIfPossible
 */
- (void)refreshToolIfPossible {
  switch (self.therapySession.currentTool.identifier) {
    case PTSToolIdentifierChangeYourPerspective:
    case PTSToolIdentifierHelpFallingAsleep:
    case PTSToolIdentifierLeisureInNature:
    case PTSToolIdentifierLeisureInTown:
    case PTSToolIdentifierLeisureTimeAlone: {
      NSString *item = [self.randomContentProvider nextContentItem];
      NSAssert([item isKindOfClass:[NSString class]], @"Expected NSString as textual content.");
      
      self.contentLabel.text = [self.randomContentProvider nextContentItem];
      
      break;
    }
      
    case PTSToolIdentifierInspiringQuotes: {
      NSDictionary *item = [self.randomContentProvider nextContentItem];
      NSAssert([item isKindOfClass:[NSDictionary class]], @"Expected NSDictionary as textual content.");
      
      self.footerLabel.text = item[@"attribution"];
      self.contentLabel.text = item[@"quote"];
      
      break;
    }
      
    case PTSToolIdentifierConnectWithOthers:
    case PTSToolIdentifierGrounding:
    case PTSToolIdentifierSootheSenses: {
      NSDictionary *item = [self.randomContentProvider nextContentItem];
      NSAssert([item isKindOfClass:[NSDictionary class]], @"Expected NSDictionary as textual content.");
      
      self.titleLabel.text = item[@"title"];
      self.contentLabel.text = item[@"tip"];
      
      break;
    }
      
    default: {
      NSAssert(FALSE, @"Invalid tool for textual content view controller.");
      break;
    }
  }
}

#pragma mark - Private Methods

/**
 *  prepareViewForDisplay
 */
- (void)prepareViewForDisplay {
  NSAssert(self.therapySession != nil, @"Textual Tool requires a valid therapy session to be set.");
  
  switch (self.therapySession.currentTool.identifier) {
    case PTSToolIdentifierInspiringQuotes: {
      self.headerLabel.hidden = YES;
      self.titleLabel.hidden = YES;
      
      break;
    }
      
    case PTSToolIdentifierConnectWithOthers:
    case PTSToolIdentifierGrounding:
    case PTSToolIdentifierSootheSenses: {
      self.headerLabel.hidden = YES;
      self.footerLabel.hidden = YES;
      
      break;
    }
      
    case PTSToolIdentifierChangeYourPerspective: {
      self.titleLabel.hidden = YES;
      self.footerLabel.hidden = YES;
      
      self.headerLabel.text = NSLocalizedString(@"Changing the way you think can change the way you "
                                                "feel. Concentrate on this more helpful thought:", nil);
      
      break;
    }
      
    case PTSToolIdentifierHelpFallingAsleep:
    case PTSToolIdentifierLeisureInNature:
    case PTSToolIdentifierLeisureInTown:
    case PTSToolIdentifierLeisureTimeAlone: {
      self.headerLabel.hidden = YES;
      self.titleLabel.hidden = YES;
      self.footerLabel.hidden = YES;
      
      break;
    }
      
    default: {
      NSAssert(FALSE, @"Invalid tool for textual content view controller.");
      break;
    }
  }

  NSURL *contentURL = self.therapySession.currentTool.contentURL;
  
  // The Change Your Perspective tool shows symptom-specific content if the user
  // arrived here by selecting on a symptom from the manage symptons screen.
  if (self.therapySession.currentTool.identifier == PTSToolIdentifierChangeYourPerspective &&
      self.therapySession.context == PTSTherapySessionContextSymptom) {
    contentURL = [self.therapySession.currentTool contentURLWithSymptom:self.therapySession.initiatingSymptom];
  }

  NSArray *contentItems = [NSArray arrayWithContentsOfURL:contentURL];
  self.randomContentProvider = [[PTSRandomContentProvider alloc] initWithContentItems:contentItems];
}

@end
