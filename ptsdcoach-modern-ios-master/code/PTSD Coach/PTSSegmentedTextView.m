//
//  PTSSegmentedTextView.m
//  PTSD Coach
//

#import "PTSSegmentedTextView.h"
#import "PTSRTFLabel.h"
#import "NSAttributedString+PTSAttributedString.h"
#import "NSString+PTSString.h"

#pragma mark - Private Interface

@interface PTSSegmentedTextView()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIStackView *stackView;

@end

#pragma mark - Implementation

@implementation PTSSegmentedTextView

#pragma mark - Lifecycle

/**
 *  initWithFrame
 */
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _useScrollView = YES;
  }
  
  return self;
}

/**
 *  initWithCoder
 */
- (instancetype)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  if (self) {
    _useScrollView = YES;
  }
  
  return self;
}

/**
 *  prepareForInterfaceBuilder
 *
 *  This is just a helper method for use within Interface Builder to make it
 *  easier to see which views in a storyboard are static text views.
 *
 */
- (void)prepareForInterfaceBuilder {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.font = [UIFont systemFontOfSize:32.0 weight:UIFontWeightSemibold];
  label.text = NSStringFromClass(self.class);
  label.textColor = [UIColor colorWithWhite:0.75 alpha:1.0];
  label.translatesAutoresizingMaskIntoConstraints = NO;

  [self addSubview:label];
  
  self.layer.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;

  [label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
  [label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
  
}

#pragma mark - Public Properties

/**
 *  setText
 */
- (void)setText:(NSString *)text {
  _text = text;
  
  [self invalidateLayout];
}

/**
 *  setAttributedText
 */
- (void)setAttributedText:(NSAttributedString *)attributedText {
  _attributedText = attributedText;
  
  [self invalidateLayout];
}

/**
 *  setUseScrollView
 */
- (void)setUseScrollView:(BOOL)useScrollView {
  _useScrollView = useScrollView;
  
  [self invalidateLayout];
}

#pragma mark - Public Methods

/**
 *  clearText
 */
- (void)clearText {
  _text = nil;
  _attributedText = nil;
  
  [self invalidateLayout];
}

#pragma mark - Private Methods

/**
 *  invalidateLayout
 */
- (void)invalidateLayout {
  // Brute-force clean up...
  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
  self.scrollView = nil;
  self.contentView = nil;
  self.stackView = nil;
  
  // Always use a stack view as the host view for the labels.
  self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
  self.stackView.axis = UILayoutConstraintAxisVertical;
  self.stackView.spacing = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].lineHeight;
  self.stackView.translatesAutoresizingMaskIntoConstraints = NO;

  if (self.shouldUseScrollView) {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.preservesSuperviewLayoutMargins = YES;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.preservesSuperviewLayoutMargins = YES;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.stackView];
    [self.scrollView addSubview:self.contentView];
    [self addSubview:self.scrollView];

    NSDictionary *views = @{ @"scrollView": self.scrollView,
                             @"contentView": self.contentView,
                             @"stackView" : self.stackView };
    
    // Pin scrollView to our edges
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    
    // Pin contentView to scrollView's edges
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];

    // Pin stackView to contentView's edges
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[stackView]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[stackView]-|" options:0 metrics:nil views:views]];

    // Explicitly restrict the width of the content view so that we enforce vertical scrolling only.
    [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor].active = YES;
  } else {
    [self addSubview:self.stackView];
    
    NSDictionary *views = @{ @"stackView" : self.stackView };
    
    // Pin stackView to our own edges.
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[stackView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[stackView]|" options:0 metrics:nil views:views]];
  }

  BOOL isUsingAttributedText = (self.attributedText ? YES : NO);
  NSArray *paragraphs = (isUsingAttributedText ?
                         [self.attributedText pts_arrayBySplittingStringIntoAttributedParagraphs] :
                         [self.text pts_arrayBySplittingStringIntoParagraphs]);
  
  UIFont *labelFont = [UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody] size:0];
  
  for (id paragraph in paragraphs) {
    PTSRTFLabel *label = [[PTSRTFLabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    
    if (isUsingAttributedText) {
      NSMutableAttributedString *mutableAttributedParagraph = [[NSMutableAttributedString alloc] initWithAttributedString:paragraph];
      [mutableAttributedParagraph addAttribute:NSFontAttributeName value:labelFont range:NSMakeRange(0, mutableAttributedParagraph.length)];
      
      label.attributedText = [mutableAttributedParagraph copy];
    } else {
      label.font = labelFont;
      label.text = paragraph;
    }
    
    [self.stackView addArrangedSubview:label];

//    if ([paragraph hasPrefix:@"•"]) {
//
//    }
  }
}

@end
