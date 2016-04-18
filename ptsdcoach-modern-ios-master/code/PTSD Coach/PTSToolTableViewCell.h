//
//  PTSToolTableViewCell.h
//  PTSD Coach
//

#import "PTSBasicTableViewCell.h"

@class PTSTool;

extern NSString *const PTSTableCellIdentifierTool;

@interface PTSToolTableViewCell : PTSBasicTableViewCell

// Public Properties
@property(nonatomic, strong, readonly) PTSTool *representedTool;

// Public Methods
- (void)prepareWithTool:(PTSTool *)tool;

@end
