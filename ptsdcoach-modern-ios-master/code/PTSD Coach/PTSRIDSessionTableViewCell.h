//
//  PTSRIDSessionTableViewCell.h
//  PTSD Coach
//

#import "PTSDetailsTableViewCell.h"

@class PTSRIDSession;

extern NSString *const PTSTableCellIdentifierRIDSession;

@interface PTSRIDSessionTableViewCell : PTSDetailsTableViewCell

// Public Properties
@property(nonatomic, strong, readonly) PTSRIDSession *representedSession;

// Public Methods
- (void)prepareWithRIDSession:(PTSRIDSession *)session;

@end
