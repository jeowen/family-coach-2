//
//  PTSWelcomeViewController.m
//  PTSD Coach
//

#import "PTSWelcomeViewController.h"
#import "PTSContentLoader.h"
#import "PTSPersonalizeViewController.h"

#pragma mark - Private Interface

@interface PTSWelcomeViewController()

@property(nonatomic, weak) IBOutlet UILabel *contentLabel;

@end

#pragma mark - Implementation

@implementation PTSWelcomeViewController

#pragma mark - UIViewController

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Don't allow navigation back to the EULA.
  self.navigationItem.hidesBackButton = YES;
  
  PTSContentLoader *contentLoader = [PTSContentLoader contentLoaderWithFilename:@"Preflight - Welcome.rtf"];
  self.contentLabel.attributedText = contentLoader.attributedString;
}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"ShowPersonalizeViewControllerSegue"]) {
    UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
    PTSPersonalizeViewController *personalizeViewController = (PTSPersonalizeViewController *)navigationController.topViewController;
    
    personalizeViewController.showDoneButton = YES;
  }
}

@end
