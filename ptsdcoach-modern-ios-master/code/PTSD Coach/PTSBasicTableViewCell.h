//
//  PTSBasicTableViewCell.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

extern NSString *const PTSTableCellIdentifierBasic;

@interface PTSBasicTableViewCell : UITableViewCell

// Public Properties
@property(nonatomic, strong) id representedObject;
@property(nonatomic, strong) NSString *primaryText;
@property(nonatomic, strong) UIColor *labelTintColor;

@end
