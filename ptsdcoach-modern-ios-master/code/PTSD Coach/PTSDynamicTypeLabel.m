//
//  PTSDynamicTypeLabel.m
//  PTSD Coach
//

#import "PTSDynamicTypeLabel.h"

#pragma mark - Implementation

@implementation PTSDynamicTypeLabel

#pragma mark - Lifecycle

/**
 *  initWithFrame
 */
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  
  return self;
}

/**
 *  initWithCoder
 */
- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self commonInit];
  }
  
  return self;
}

/**
 *  awakeFromNib
 */
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self updateFont];
}

/**
 *  dealloc
 */
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Properties

/**
 *  fontDescriptor
 */
- (UIFontDescriptor *)fontDescriptor {
  if (_fontDescriptor) {
    return _fontDescriptor;
  }
  
  NSString *textStyle = (self.fontTextStyle ? self.fontTextStyle : UIFontTextStyleBody);
  
  return [UIFontDescriptor preferredFontDescriptorWithTextStyle:textStyle];
}

/**
 *  setFontTextStyle
 */
- (void)setFontTextStyle:(NSString *)fontTextStyle {
  _fontTextStyle = fontTextStyle;
  
  [self updateFont];
}

#pragma mark - Notification Handlers

/**
 *  handleContentSizeCategoryDidChangeNotification
 */
- (void)handleContentSizeCategoryDidChangeNotification:(NSNotification *)notification {
  [self updateFont];
}

#pragma mark - Private Methods

/**
 *  commonInit
 */
- (void)commonInit {
  [self updateFont];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleContentSizeCategoryDidChangeNotification:)
                                               name:UIContentSizeCategoryDidChangeNotification
                                             object:nil];
  
}

/**
 *  updateFont
 */
- (void)updateFont {
  self.font = [UIFont fontWithDescriptor:self.fontDescriptor size:0];
}

@end
