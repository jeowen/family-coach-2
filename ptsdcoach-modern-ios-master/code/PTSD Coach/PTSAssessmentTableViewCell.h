//
//  PTSAssessmentTableViewCell.h
//  PTSD Coach
//

#import "PTSDetailsTableViewCell.h"

@class PTSAssessment;

extern NSString *const PTSTableCellIdentifierAssessment;

@interface PTSAssessmentTableViewCell : PTSDetailsTableViewCell

// Public Properties
@property(nonatomic, strong, readonly) PTSAssessment *representedAssessment;

// Public Methods
- (void)prepareWithAssessment:(PTSAssessment *)assessment;

@end
