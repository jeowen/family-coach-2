//
//  PTSDurationPickerViewController.m
//  PTSD Coach
//

#import "PTSDurationPickerViewController.h"

#pragma mark - Private Interface

@interface PTSDurationPickerViewController()

@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property(nonatomic, weak) IBOutlet UIButton *doneButton;
@property(nonatomic, weak) IBOutlet UIStackView *stackView;

@end

#pragma mark - Implementation

@implementation PTSDurationPickerViewController

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.titleLabel.text = self.title;
}

/**
 *  preferredContentSize
 */
- (CGSize)preferredContentSize {
  [self.stackView setNeedsLayout];
  [self.stackView layoutIfNeeded];
  
  return [self.stackView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

#pragma mark - IBActions

/**
 *  handleDoneButtonPressed
 */
- (IBAction)handleDoneButtonPressed:(id)sender {
  if (self.callbackBlock) {
    NSTimeInterval duration = (NSTimeInterval)([self.pickerView selectedRowInComponent:0] + 1);
    
    // Convert duration to seconds
    duration = duration * 60;
    
    self.callbackBlock(duration);
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDataSource Methods

/**
 *  pickerView:titleForRow
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [NSString stringWithFormat:@"%@", @(row + 1)];
}

#pragma mark - UIPickerViewDelegate Methods

/**
 *  numberOfComponentsInPickerView
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

/**
 *  pickerView:numberOfRowsInComponent
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 60;
}

@end
