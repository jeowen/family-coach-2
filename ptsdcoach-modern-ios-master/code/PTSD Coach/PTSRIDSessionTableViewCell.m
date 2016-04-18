//
//  PTSRIDSessionTableViewCell.m
//  PTSD Coach
//

#import "PTSRIDSessionTableViewCell.h"
#import "PTSRIDSession.h"

NSString *const PTSTableCellIdentifierRIDSession = @"PTSTableCellIdentifierRIDSession";

#pragma mark - Private Interface

@interface PTSRIDSessionTableViewCell()

@property(nonatomic, strong, readwrite) PTSRIDSession *representedSession;

@end

#pragma mark - Implementation

@implementation PTSRIDSessionTableViewCell

#pragma mark - Public Methods

/**
 *  prepareWithRIDSession
 */
- (void)prepareWithRIDSession:(PTSRIDSession *)session {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateStyle = NSDateFormatterShortStyle;
  dateFormatter.timeStyle = NSDateFormatterNoStyle;

  self.representedSession = session;
  
  self.primaryText = session.triggeringCauseResponse;
  self.secondaryText = [dateFormatter stringFromDate:session.date];
}

@end
