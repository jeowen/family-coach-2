//
//  PTSAssessmentTableViewCell.m
//  PTSD Coach
//

#import "PTSAssessmentTableViewCell.h"
#import "PTSAssessment.h"

NSString *const PTSTableCellIdentifierAssessment = @"PTSTableCellIdentifierAssessment";

#pragma mark - Private Interface

@interface PTSAssessmentTableViewCell()

@property(nonatomic, strong, readwrite) PTSAssessment *representedAssessment;

@end

#pragma mark - Implementation

@implementation PTSAssessmentTableViewCell

#pragma mark - Public Methods

/**
 *  prepareWithAssessment
 */
- (void)prepareWithAssessment:(PTSAssessment *)assessment {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateStyle = NSDateFormatterMediumStyle;
  dateFormatter.timeStyle = NSDateFormatterNoStyle;

  self.representedAssessment = assessment;
  
  self.primaryText = [dateFormatter stringFromDate:assessment.date];
  self.secondaryText = [NSString stringWithFormat:NSLocalizedString(@"Score: %@", nil), @(assessment.score)];
}

@end
