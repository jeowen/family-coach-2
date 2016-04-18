//
//  PTSDetailsTableViewCell.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

extern NSString *const PTSTableCellIdentifierDetails;

@interface PTSDetailsTableViewCell : UITableViewCell

// Public Properties
@property(nonatomic, strong) NSString *primaryText;
@property(nonatomic, strong) NSString *secondaryText;

@end
