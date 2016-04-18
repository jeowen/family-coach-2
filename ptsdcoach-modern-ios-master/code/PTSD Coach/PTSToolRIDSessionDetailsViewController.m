//
//  PTSToolRIDSessionDetailsViewController.m
//  PTSD Coach
//

#import "PTSToolRIDSessionDetailsViewController.h"
#import "PTSRIDSession.h"

#pragma mark - Private Interface

@interface PTSToolRIDSessionDetailsViewController()

@property(nonatomic, weak) IBOutlet UILabel *dateLabel;
@property(nonatomic, weak) IBOutlet UILabel *triggerLabel;
@property(nonatomic, weak) IBOutlet UILabel *situationLabel;
@property(nonatomic, weak) IBOutlet UILabel *decisionLabel;

@end

@implementation PTSToolRIDSessionDetailsViewController

#pragma mark - UIViewController Methods

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateStyle = NSDateFormatterMediumStyle;
  dateFormatter.timeStyle = NSDateFormatterNoStyle;
  
  self.dateLabel.text = [dateFormatter stringFromDate:self.session.date];
  self.triggerLabel.text = self.session.triggeringCauseResponse;
  self.situationLabel.text = self.session.situationExperienceResponse;
  self.decisionLabel.text = self.session.decisionResponse;
}

@end
