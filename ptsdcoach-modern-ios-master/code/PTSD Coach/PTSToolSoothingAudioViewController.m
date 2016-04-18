//
//  PTSToolSoothingAudioViewController.m
//  PTSD Coach
//

#import "PTSToolSoothingAudioViewController.h"
#import "PTSSongPlayerViewController.h"
#import "PTSTool.h"

static NSString *const PTSSegueIdentifierEmbedSongPlayer = @"EmbedSongPlayerSegue";

#pragma mark - Private Interface

@interface PTSToolSoothingAudioViewController()

@end

#pragma mark - Implementation

@implementation PTSToolSoothingAudioViewController

#pragma mark - UIViewControllerMethods

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierEmbedSongPlayer]) {
    PTSSongPlayerViewController *songPlayerViewController = (PTSSongPlayerViewController *)segue.destinationViewController;
    songPlayerViewController.embeddedInContainerView = YES;
    songPlayerViewController.listSource = PTSSongPlayerListSourceSoothingAudio;
    songPlayerViewController.songPickerViewTitle = self.tool.title;
  }
}

@end
