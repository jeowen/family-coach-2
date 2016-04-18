//
//  PTSDurationPickerViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

typedef void (^PTSDurationPickerViewControllerCallbackBlock)(NSTimeInterval);

@interface PTSDurationPickerViewController : UIViewController

@property(nonatomic, strong) PTSDurationPickerViewControllerCallbackBlock callbackBlock;

@end
