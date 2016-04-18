//
//  PTSContactsViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

@class CNContact;

@interface PTSContactsViewController : UITableViewController

// Public Properties
@property(nonatomic, strong) UIView *headerView;

// Public Methods
- (void)initiateAddContactExperience;

@end
