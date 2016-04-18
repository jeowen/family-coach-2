//
//  PTSSegmentedTextView.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface PTSSegmentedTextView : UIView

// Public Properties
@property(nonatomic, assign, getter = shouldUseScrollView) IBInspectable BOOL useScrollView;

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSAttributedString *attributedText;

// Public Methods
- (void)clearText;

@end
