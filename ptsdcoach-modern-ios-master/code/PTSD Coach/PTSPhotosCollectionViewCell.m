//
//  PTSPhotosCollectionViewCell.m
//  PTSD Coach
//

#import "PTSPhotosCollectionViewCell.h"

#pragma mark - Implementation

@implementation PTSPhotosCollectionViewCell

#pragma mark - NSResponder Methods

/**
 *  delete
 */
- (void)delete:(id)sender {
  // This seems like an awfully convoluted way of calling back to parent view controller, but
  // apparently you need to perform this gymnastics routine when using items in the cell
  // contextual menu that are not Cut/Copy/Paste... /shrug
  
  if (self.deleteActionBlock) {
    self.deleteActionBlock(self);
  }
}

@end
