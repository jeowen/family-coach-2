//
//  PTSPhotosCollectionViewCell.h
//  PTSD Coach
//

#import <UIKit/UIKit.h>

@class PTSPhotosCollectionViewCell;

typedef void (^PTSPhotosCollectionViewCellDeleteActionBlock)(PTSPhotosCollectionViewCell *);

@interface PTSPhotosCollectionViewCell : UICollectionViewCell

// Public Properties
@property(nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) PTSPhotosCollectionViewCellDeleteActionBlock deleteActionBlock;

@end
