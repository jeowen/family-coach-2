//
//  PTSSongsViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

typedef void (^PTSSongsViewControllerCallbackBlock)(NSArray *);

@interface PTSSongsViewController : UITableViewController

// Public Properties
@property(nonatomic, strong) NSArray *mediaItems;
@property(nonatomic, strong) PTSSongsViewControllerCallbackBlock callbackBlock;

@end
