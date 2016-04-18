//
//  PTSToolSelfGuidedExerciseViewController.m
//  PTSD Coach
//

#import "PTSToolSelfGuidedExerciseViewController.h"
#import "PTSContentLoader.h"
#import "PTSSegmentedTextView.h"
#import "PTSTool.h"

#pragma mark - Private Interface

@interface PTSToolSelfGuidedExerciseViewController()

@property(nonatomic, weak) IBOutlet PTSSegmentedTextView *segmentedTextView;

@end

@implementation PTSToolSelfGuidedExerciseViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  PTSContentLoader *contentLoader = [PTSContentLoader contentLoaderWithURL:self.tool.selfGuidedContentURL];
  self.segmentedTextView.attributedText = contentLoader.attributedString;
}

#pragma mark - PTSToolViewDelegate Methods

/**
 *  wantsFadeTransition
 */
- (BOOL)wantsFadeTransition {
  return YES;
}

@end
