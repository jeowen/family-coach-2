//
//  PTSHelpViewerViewController.m
//  PTSD Coach
//

#import "PTSHelpViewerViewController.h"
#import "PTSContentLoader.h"
#import "PTSSegmentedTextView.h"

static NSDictionary *sSubjectToFilenameMappings;

#pragma mark - Private Interface

@interface PTSHelpViewerViewController ()

@property(nonatomic, weak) IBOutlet PTSSegmentedTextView *textView;

@end

#pragma mark - Implementation

@implementation PTSHelpViewerViewController

#pragma mark - Class Methods

/**
 *  initializer
 */
+ (void)initialize {
  sSubjectToFilenameMappings = @{ @(PTSHelpViewerSubjectTrackSymptoms) : @"Track Symptoms - Main Help.rtf",
                                  @(PTSHelpViewerSubjectDistressMeter) : @"Manage Symptoms - Distress Meter Help.rtf" };
}

#pragma mark - UIViewController Methods

/**
 *  viewWillAppear
 */
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self updateViewerContentWithSubject:self.subject];
}

#pragma mark - IBActions

/**
 *  dismissHelpViewer
 */
- (IBAction)dismissHelpViewer:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

/**
 *  updateViewerContentWithSubject
 */
- (void)updateViewerContentWithSubject:(PTSHelpViewerSubject)subject {
  NSString *filename = sSubjectToFilenameMappings[@(subject)];
  PTSContentLoader *contentLoader = [PTSContentLoader contentLoaderWithFilename:filename];
  self.textView.attributedText = contentLoader.attributedString;
}

@end
