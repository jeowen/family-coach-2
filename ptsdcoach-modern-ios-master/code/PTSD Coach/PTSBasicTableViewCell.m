//
//  PTSBasicTableViewCell.m
//  PTSD Coach
//

#import "PTSBasicTableViewCell.h"
#import "PTSDynamicTypeLabel.h"

NSString *const PTSTableCellIdentifierBasic = @"PTSTableCellIdentifierBasic";

#pragma mark - Private Interface

@interface PTSBasicTableViewCell()

@property(nonatomic, strong) PTSDynamicTypeLabel *primaryLabel;

@end

#pragma mark - Implementation

@implementation PTSBasicTableViewCell

/**
 *  initWithFrame
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self commonInit];
  }
  
  return self;
}

/**
 *  initWithCoder
 */
- (instancetype)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  if (self) {
    [self commonInit];
  }
  
  return self;
}

#pragma mark - Public Properties

/**
 *  setText
 */
- (void)setPrimaryText:(NSString *)primaryText {
  _primaryText = primaryText;
  self.primaryLabel.text = primaryText;
}

/**
 *  setLabelTintColor
 */
- (void)setLabelTintColor:(UIColor *)labelTintColor {
  self.primaryLabel.textColor = labelTintColor;
}

#pragma mark - Private Methods

/**
 *  commonInit
 */
- (void)commonInit {
  NSAssert(!self.primaryLabel, @"Common init should only be called once.");

  self.primaryLabel = [[PTSDynamicTypeLabel alloc] initWithFrame:CGRectZero];
  self.primaryLabel.fontTextStyle = UIFontTextStyleBody;
  self.primaryLabel.numberOfLines = 0;
  self.primaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.contentView addSubview:self.primaryLabel];
  
  [self.primaryLabel.leftAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leftAnchor].active = YES;
  [self.primaryLabel.rightAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.rightAnchor].active = YES;
  [self.primaryLabel.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor].active = YES;
  [self.primaryLabel.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor].active = YES;
  
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
