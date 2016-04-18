//
//  PTSPhotosViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

typedef void (^PTSPhotosViewControllerCallbackBlock)(NSArray *);

@interface PTSPhotosViewController : UICollectionViewController

// Public Properties
@property(nonatomic, strong) NSArray *photos;
@property(nonatomic, strong) PTSPhotosViewControllerCallbackBlock callbackBlock;

@end
