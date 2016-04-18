//
//  PTSSongPlayerViewController.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PTSSongPlayerListSource) {
  PTSSongPlayerListSourceMindfulListening,
  PTSSongPlayerListSourceSoothingAudio
};

@interface PTSSongPlayerViewController : UIViewController

// Public Properties
@property(nonatomic, assign, getter = isEmbeddedInContainerView) BOOL embeddedInContainerView;
@property(nonatomic, assign) PTSSongPlayerListSource listSource;
@property(nonatomic, strong) NSString *songPickerViewTitle;

@end
