//
//  PTSDetailsTableViewCell.m
//  PTSD Coach
//

#import "PTSDetailsTableViewCell.h"
#import "PTSDynamicTypeLabel.h"

NSString *const PTSTableCellIdentifierDetails = @"PTSTableCellIdentifierDetails";

#pragma mark - Private Interface

@interface PTSDetailsTableViewCell()

@property(nonatomic, strong) PTSDynamicTypeLabel *primaryLabel;
@property(nonatomic, strong) PTSDynamicTypeLabel *secondaryLabel;

@end

#pragma mark - Implementation

@implementation PTSDetailsTableViewCell

#pragma mark - Lifecycle

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
 *  primaryText
 */
- (NSString *)primaryText {
  return self.primaryLabel.text;
}

/**
 *  setPrimaryText
 */
- (void)setPrimaryText:(NSString *)primaryText {
  self.primaryLabel.text = primaryText;
}

/**
 *  secondaryText
 */
- (NSString *)secondaryText {
  return self.secondaryLabel.text;
}

/**
 *  setSecondaryText
 */
- (void)setSecondaryText:(NSString *)secondaryText {
  self.secondaryLabel.text = secondaryText;
}

#pragma mark - Private Methods

/**
 *  commonInit
 */
- (void)commonInit {
  NSAssert(!self.primaryLabel && !self.secondaryLabel, @"Common init should only be called once.");
  
  self.primaryLabel = [[PTSDynamicTypeLabel alloc] initWithFrame:CGRectZero];
  self.primaryLabel.fontTextStyle = UIFontTextStyleBody;
  self.primaryLabel.numberOfLines = 0;
  self.primaryLabel.translatesAutoresizingMaskIntoConstraints = NO;

  self.secondaryLabel = [[PTSDynamicTypeLabel alloc] initWithFrame:CGRectZero];
  self.secondaryLabel.fontTextStyle = UIFontTextStyleBody;
  self.secondaryLabel.textColor = [UIColor darkGrayColor];
  self.secondaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Allow the primary label to compress before the secondary label.
  [self.primaryLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
  
  [self.contentView addSubview:self.primaryLabel];
  [self.contentView addSubview:self.secondaryLabel];
  
  [self.primaryLabel.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor].active = YES;
  [self.primaryLabel.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor].active = YES;
  [self.primaryLabel.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor].active = YES;
  [self.primaryLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.secondaryLabel.leadingAnchor constant:-4.0].active = YES;
  
  [self.secondaryLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
  [self.secondaryLabel.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor].active = YES;

  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
