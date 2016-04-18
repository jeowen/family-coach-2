//
//  PTSRemindersViewController.m
//  PTSD Coach
//

#import "PTSRemindersViewController.h"
#import "PTSDatastore.h"
#import "PTSDatePickerTableViewCell.h"
#import "PTSReminderManager.h"

const NSInteger PTSRemindersViewDatePickerTagAssessments = 100;
const NSInteger PTSRemindersViewDatePickerTagDailyQuote = 101;

typedef NS_ENUM(NSInteger, PTSRemindersViewTableSection) {
  PTSRemindersViewTableSectionAssessments = 0,
  PTSRemindersViewTableSectionDailyQuote
};

#pragma mark - Private Methods

@interface PTSRemindersViewController()

@property(nonatomic, assign, getter = isEditingDailyQuote) BOOL editingDailyQuote;
@property(nonatomic, assign, getter = isEditingAssessmentReminder) BOOL editingAssessmentReminder;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong, readonly) PTSReminderManager *reminderManager;

@end

@implementation PTSRemindersViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  self.editingDailyQuote = NO;
  self.editingAssessmentReminder = NO;
  
  self.dateFormatter = [[NSDateFormatter alloc] init];

  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource Methods

/**
 *  numberOfSectionsInTableView
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == PTSRemindersViewTableSectionAssessments) {
    if (self.reminderManager.isAssessmentReminderEnabled && self.isEditingAssessmentReminder) {
      return 3;
    } else if (self.reminderManager.isAssessmentReminderEnabled) {
      return 2;
    } else {
      return 1;
    }
  } else if (section == PTSRemindersViewTableSectionDailyQuote) {
    if (self.reminderManager.isInspiringQuoteNotificationEnabled && self.isEditingDailyQuote) {
      return 3;
    } else if (self.reminderManager.isInspiringQuoteNotificationEnabled) {
      return 2;
    } else {
      return 1;
    }
  }
  
  return 0;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  
  UITableViewCell *(^switchCellWithTitle)(NSString *, BOOL, SEL) = ^UITableViewCell *(NSString *title, BOOL switchEnabled, SEL selector) {
    UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchControl.on = switchEnabled;
    [switchControl addTarget:self
                      action:selector
            forControlEvents:UIControlEventValueChanged];
    
    UITableViewCell *factoryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    factoryCell.accessoryView = switchControl;
    factoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    factoryCell.textLabel.text = title;
    
    return factoryCell;
  };
  
  if (indexPath.row == 0) {
    
    if (indexPath.section == PTSRemindersViewTableSectionAssessments) {
      cell = switchCellWithTitle(NSLocalizedString(@"Assessment Reminder", nil),
                                 self.reminderManager.isAssessmentReminderEnabled,
                                 @selector(handleAssessmentReminderSwitchValueChanged:));
    } else if (indexPath.section == PTSRemindersViewTableSectionDailyQuote) {
      cell = switchCellWithTitle(NSLocalizedString(@"Daily Inspiring Quote", nil),
                                 self.reminderManager.isInspiringQuoteNotificationEnabled,
                                 @selector(handleDailyQuoteSwitchValueChanged:));
    }
    
  } else if (indexPath.row == 1) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

    if (indexPath.section == PTSRemindersViewTableSectionAssessments) {
      NSDate *assessmentDate = self.reminderManager.assessmentReminderDate;
      
      self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
      self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
      
      cell.textLabel.text = NSLocalizedString(@"Next Reminder", nil);
      if (assessmentDate) {
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:assessmentDate];
      } else {
        cell.detailTextLabel.text = NSLocalizedString(@"Not Set", nil);
      }
      
    } else if (indexPath.section == PTSRemindersViewTableSectionDailyQuote) {
      NSDate *dailyQuoteDate = self.reminderManager.inspiringQuoteNotificationDate;
      
      self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
      self.dateFormatter.timeStyle = NSDateFormatterShortStyle;

      cell.textLabel.text = NSLocalizedString(@"Next Notification", nil);
      if (dailyQuoteDate) {
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:dailyQuoteDate];
      } else {
        cell.detailTextLabel.text = NSLocalizedString(@"Not Set", nil);
      }
    }
    
  } else if (indexPath.row == 2) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    UIDatePicker *datePicker = ((PTSDatePickerTableViewCell *)cell).datePicker;
    [datePicker addTarget:self
                   action:@selector(handleDatePickerValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    if (indexPath.section == PTSRemindersViewTableSectionAssessments) {
      NSDate *date = self.reminderManager.assessmentReminderDate;
      
      datePicker.date = (date ? date : [NSDate date]);
      datePicker.datePickerMode = UIDatePickerModeDateAndTime;
      datePicker.minimumDate = [NSDate date];
      datePicker.tag = PTSRemindersViewDatePickerTagAssessments;
    } else if (indexPath.section == PTSRemindersViewTableSectionDailyQuote) {
      NSDate *date = self.reminderManager.inspiringQuoteNotificationDate;
      
      datePicker.date = (date ? date : [NSDate date]);
      datePicker.datePickerMode = UIDatePickerModeTime;
      datePicker.tag = PTSRemindersViewDatePickerTagDailyQuote;
    }
  }
  
  cell.accessoryType = UITableViewCellAccessoryNone;

  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // We're only interested in taps on the second row, which toggle the date pickers.
  if (indexPath.row != 1) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
  }
  
  [tableView beginUpdates];
  
  switch (indexPath.section) {
    case PTSRemindersViewTableSectionAssessments: {
      // If they tapped on the date-time row and we're not already editing, then begin
      // editing. Otherwise if they tapped anywhere else, then end editing.
      self.editingAssessmentReminder = (indexPath.row == 1 && !self.isEditingAssessmentReminder);

      break;
    }
      
    case PTSRemindersViewTableSectionDailyQuote: {
      // See note above
      self.editingDailyQuote = (indexPath.row == 1 && !self.isEditingDailyQuote);
      
      break;
    }
  }

  [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
           withRowAnimation:UITableViewRowAnimationFade];

  [tableView endUpdates];
}

#pragma mark - Action Handlers

/**
 *  handleAssessmentReminderSwitchValueChanged
 */
- (void)handleAssessmentReminderSwitchValueChanged:(id)sender {
  self.reminderManager.assessmentReminderEnabled = ((UISwitch *)sender).isOn;
  
  self.editingAssessmentReminder = NO;

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:PTSRemindersViewTableSectionAssessments]
                withRowAnimation:UITableViewRowAnimationFade];
}

/**
 *  handleDailyQuoteSwitchValueChanged
 */
- (void)handleDailyQuoteSwitchValueChanged:(id)sender {
  self.reminderManager.inspiringQuoteNotificationEnabled = ((UISwitch *)sender).isOn;

  self.editingDailyQuote = NO;

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:PTSRemindersViewTableSectionDailyQuote]
                withRowAnimation:UITableViewRowAnimationFade];
}

/**
 *  handleDatePickerValueDidChange
 */
- (void)handleDatePickerValueDidChange:(id)sender {
  UIDatePicker *datePicker = (UIDatePicker *)sender;
  
  if (datePicker.tag == PTSRemindersViewDatePickerTagAssessments) {
    self.reminderManager.assessmentReminderDate = datePicker.date;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:PTSRemindersViewTableSectionAssessments]]
                          withRowAnimation:UITableViewRowAnimationNone];
    
  } else if (datePicker.tag == PTSRemindersViewDatePickerTagDailyQuote) {
    self.reminderManager.inspiringQuoteNotificationDate = datePicker.date;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:PTSRemindersViewTableSectionDailyQuote]]
                          withRowAnimation:UITableViewRowAnimationNone];
  }
}

#pragma mark - Private Methods

#pragma mark - Private Properties

/**
 *  reminderManager
 */
- (PTSReminderManager *)reminderManager {
  return [PTSDatastore sharedDatastore].reminderManager;
}

@end
