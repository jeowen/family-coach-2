//
//  PTSToolRIDIntroViewController.m
//  PTSD Coach
//

#import "PTSToolRIDIntroViewController.h"
#import "PTSRIDSession.h"
#import "PTSDatastore.h"

#pragma mark - Private Interface

@interface PTSToolRIDIntroViewController()

@property(nonatomic, weak) IBOutlet UIButton *showHistoryButton;

@end

#pragma mark - Implementation

@implementation PTSToolRIDIntroViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.RIDSession = [[PTSRIDSession alloc] init];
  self.RIDSession.date = [NSDate date];
}

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.showHistoryButton.hidden = ([PTSDatastore sharedDatastore].RIDSessions.count < 1);
}

@end
