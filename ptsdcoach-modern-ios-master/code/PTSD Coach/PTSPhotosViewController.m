//
//  PTSPhotosViewController.m
//  PTSD Coach
//

@import MobileCoreServices;

#import "PTSPhotosViewController.h"
#import "PTSPhotosCollectionViewCell.h"

#pragma mark - Private Interface

@interface PTSPhotosViewController()<UICollectionViewDelegateFlowLayout,
                                     UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate>

@property(nonatomic, strong) IBOutlet UILabel *noImagesLabel;

@end

#pragma mark - Implementation

@implementation PTSPhotosViewController

#pragma mark - Public Properties

/**
 *  setPhotos
 */
- (void)setPhotos:(NSArray *)photos {
  _photos = photos;
  
  [self toggleBackgroundViewIfNecessary];
}

#pragma mark - IBActions

/**
 *  handleAddPhotoButton
 */
- (IBAction)handleAddPhotoButton:(id)sender {
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.allowsEditing = NO;
  imagePicker.delegate = self;
  imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  
  
  [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

/**
 *  imagePickerController:didFinishPickingMediaWithInfo
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  
  NSString *mediaType = info[UIImagePickerControllerMediaType];
  
  if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
    UIImage *chosenImage = (UIImage *) info[UIImagePickerControllerOriginalImage];
    
    if (chosenImage) {
      
      if (!self.photos) {
        self.photos = @[];
      }
      
      self.photos = [self.photos arrayByAddingObject:chosenImage];

      [self toggleBackgroundViewIfNecessary];
      [self.collectionView reloadData];
      
      if (self.callbackBlock) {
        self.callbackBlock(self.photos);
      }
    }
  }

  [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  imagePickerControllerDidCancel
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UICollectionViewDataSource Methods

/**
 *  numberOfSectionsInCollectionView
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

/**
 *  collectionView:numberOfItemsInSection
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.photos.count;
}

/**
 *  collectionView:cellForItemAtIndexpath
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PTSPhotosCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoItemCollectionViewCellIdentifier"
                                                                                     forIndexPath:indexPath];
  
  PTSPhotosViewController *__weak weakSelf = self;
  
  UIImage *image = self.photos[indexPath.row];
  photoCell.imageView.image = image;
  photoCell.deleteActionBlock = ^(PTSPhotosCollectionViewCell *deletionCell) {
    PTSPhotosViewController *strongSelf = weakSelf;
    if (!strongSelf || strongSelf.photos.count < 1) {
      return;
    }
    
    NSMutableArray *mutablePhotos = [[NSMutableArray alloc] initWithArray:strongSelf.photos];
    [mutablePhotos removeObject:image];
    
    strongSelf.photos = [mutablePhotos copy];

    [strongSelf toggleBackgroundViewIfNecessary];
    [strongSelf.collectionView reloadData];

    if (strongSelf.callbackBlock) {
      strongSelf.callbackBlock(strongSelf.photos);
    }
  };
  
  return photoCell;
}

#pragma mark UICollectionViewDelegate Methods

/**
 *  collectionView:shouldSelectItemAtIndexPath
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

/**
 *  collectionView:shouldShowMenuForItemAtIndexPath
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

/**
 *  collectionView:canPerformAction:forItemAtIndexPath:withSender
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
  return (action == @selector(delete:));
}

/**
 *  collectionView:performAction:forItemAtIndexPath:withSender
 */
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
  // This is a no-op since we're using the delete: selector declared in PTSPhotosCollectionViewCell.
  // This method must be declared for the two methods above to work as noted in UICollectionView.h
}

#pragma mark - UICollectionViewDelegateFlowLayout Methods

/**
 *  collectionView:layout:sizeForItemAtIndexPath
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  const NSUInteger kRowCount = 4;
  CGFloat cellWidth = floor((CGRectGetWidth(self.view.frame) - (kRowCount - 1)) / kRowCount);
  CGFloat cellHeight = cellWidth;

  return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - Private Methods

/**
 *  toggleBackgroundViewIfNecessary
 */
- (void)toggleBackgroundViewIfNecessary {
  if (self.photos.count > 0) {
    self.collectionView.backgroundView = nil;
  } else {
    self.collectionView.backgroundView = self.noImagesLabel;
  }
}

@end
