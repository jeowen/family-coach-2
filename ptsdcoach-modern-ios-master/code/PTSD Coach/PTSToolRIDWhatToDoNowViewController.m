//
//  PTSToolRIDWhatToDoNowViewController.m
//  PTSD Coach
//

#import "PTSToolRIDWhatToDoNowViewController.h"
#import "PTSRIDSession.h"

#pragma mark - Private Interface

@interface PTSToolRIDWhatToDoNowViewController()

@property(nonatomic, weak) IBOutlet UITextView *textView;

@end

#pragma mark - Implementation

@implementation PTSToolRIDWhatToDoNowViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Hide the Back button because we show a "Finish" button in the top right corner.
  self.navigationItem.hidesBackButton = YES;
}

/**
 *  prepareForSegue:sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  self.RIDSession.decisionResponse = self.textView.text;
  
  [super prepareForSegue:segue sender:sender];
}

@end
