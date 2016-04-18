//
//  PTSToolTableViewCell.m
//  PTSD Coach
//

#import "PTSToolTableViewCell.h"
#import "PTSTool.h"

NSString *const PTSTableCellIdentifierTool = @"PTSTableCellIdentifierTool";

#pragma mark - Private Interface

@interface PTSToolTableViewCell()

@property(nonatomic, strong, readwrite) PTSTool *representedTool;

@end

#pragma mark - Implementation

@implementation PTSToolTableViewCell

#pragma mark - Public Methods

/**
 *  prepareWithTool
 */
- (void)prepareWithTool:(PTSTool *)tool {
  self.representedTool = tool;
  self.primaryText = tool.title;
}

@end
