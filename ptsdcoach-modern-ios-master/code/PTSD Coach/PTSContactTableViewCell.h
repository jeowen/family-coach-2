//
//  PTSContactTableViewCell.h
//  PTSD Coach
//

#import "PTSBasicTableViewCell.h"

@class CNContact;

@interface PTSContactTableViewCell : PTSBasicTableViewCell

// Public Methods
- (void)prepareWithContact:(CNContact *)contact;

@end
