//
//  PTSToolAudioExerciseIntroViewController.m
//  PTSD Coach
//

#import "PTSToolAudioExerciseIntroViewController.h"
#import "PTSContentLoader.h"
#import "PTSSegmentedTextView.h"
#import "PTSTool.h"

#pragma mark - Private Interface

@interface PTSToolAudioExerciseIntroViewController()

@property(nonatomic, weak) IBOutlet PTSSegmentedTextView *segmentedTextView;
@property(nonatomic, weak) IBOutlet UIButton *selfGuidedButton;

@end

#pragma mark - Implementation

@implementation PTSToolAudioExerciseIntroViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  PTSContentLoader *contentLoader = [PTSContentLoader contentLoaderWithURL:self.tool.audioExerciseIntroURL];
  self.segmentedTextView.text = contentLoader.plainString;
  
  // The following tools do not have a self-guided section.
  if (self.tool.identifier == PTSToolIdentifierPositiveImageryBeach ||
      self.tool.identifier == PTSToolIdentifierPositiveImageryCountryRoad ||
      self.tool.identifier == PTSToolIdentifierPositiveImageryForest) {
    self.selfGuidedButton.hidden = YES;
  }
}

/**
 *  prepareForSegue:sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Manually set the tool because the therapy session did not instantiate the destination view controller.
  if ([segue.destinationViewController respondsToSelector:@selector(setTool:)]) {
    [segue.destinationViewController performSelector:@selector(setTool:) withObject:self.tool];
  }
}

@end
