//
//  PTSDistressCrisisResourcesViewController.m
//  PTSD Coach
//

#import "PTSDistressCrisisResourcesViewController.h"
#import "PTSContactsViewController.h"

#pragma mark - Private Interface

@interface PTSDistressCrisisResourcesViewController()

@property(nonatomic, strong) IBOutlet UIView *headerView;

@end

#pragma mark - Implementation

@implementation PTSDistressCrisisResourcesViewController

#pragma mark - UIViewController Methods

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"ContactsEmbeddedSegue"]) {
    PTSContactsViewController *contactsViewController = (PTSContactsViewController *)segue.destinationViewController;
    contactsViewController.headerView = self.headerView;
  }
}

#pragma mark - PTSToolViewDelegate Methods

/**
 *  wantsToolbarHidden
 */
- (BOOL)wantsToolbarHidden {
  return YES;
}

@end
