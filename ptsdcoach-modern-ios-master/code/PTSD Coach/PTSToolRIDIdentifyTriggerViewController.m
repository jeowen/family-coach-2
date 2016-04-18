//
//  PTSToolRIDIdentifyTriggerViewController.m
//  PTSD Coach
//

#import "PTSToolRIDIdentifyTriggerViewController.h"
#import "PTSRIDSession.h"

#pragma mark - Private Interface

@interface PTSToolRIDIdentifyTriggerViewController()<UITextViewDelegate>

@property(nonatomic, weak) IBOutlet UITextView *triggeredTextView;
@property(nonatomic, weak) IBOutlet UITextView *experienceTextView;
@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property(nonatomic, weak) UITextView *activeTextView;

@end

#pragma mark - Implementation

@implementation PTSToolRIDIdentifyTriggerViewController

#pragma mark - Lifecycle

/**
 *  dealloc
 */
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleKeyboardDidShowNotification:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleKeyboardWillHideNotification:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  self.RIDSession.triggeringCauseResponse = self.triggeredTextView.text;
  self.RIDSession.situationExperienceResponse = self.experienceTextView.text;
  
  [super prepareForSegue:segue sender:sender];
}

#pragma mark - IBActions

/**
 *  handleTapGestureRecognizer
 */
- (IBAction)handleTapGestureRecognizer:(id)sender {
  [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate Methods

/**
 *  textViewDidBeginEditing
 */
- (void)textViewDidBeginEditing:(UITextView *)textView {
  self.activeTextView = textView;
}

/**
 *  textViewDidEndEditing
 */
- (void)textViewDidEndEditing:(UITextView *)textView {
  self.activeTextView = nil;
}

#pragma mark - Event Handlers

/**
 *  handleKeyboardDidShowNotification
 */
- (void)handleKeyboardDidShowNotification:(NSNotification *)notification {
  NSDictionary *info = notification.userInfo;
  CGRect keyboardFrame = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  
  // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
  // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
  //kbRect = [self.view convertRect:kbRect fromView:nil];
  
//  UIEdgeInsets contentInsets = self.scrollView.contentInset UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(keyboardFrame), 0.0);
  UIEdgeInsets contentInsets = self.scrollView.contentInset;
  contentInsets.bottom = CGRectGetHeight(keyboardFrame);
  
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;
  
//  CGRect aRect = self.view.frame;
//  aRect.size.height -= CGRectGetHeight(keyboardFrame);
  
//  if (!CGRectContainsPoint(aRect, self.activeTextView.frame.origin) ) {
//    [self.scrollView scrollRectToVisible:self.activeTextView.frame animated:YES];
//  }
}

/**
 *  handleKeyboardWillHideNotification
 */
- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
  NSDictionary *info = notification.userInfo;
  CGRect keyboardFrame = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];

  UIEdgeInsets contentInsets = self.scrollView.contentInset;
  contentInsets.bottom = 44;
  
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;
  
//  [self.scrollView scrollRectToVisible:CGRectZero animated:YES];
}

@end
