//
//  PTSContentLoader.m
//  PTSD Coach
//

@import UIKit;
#import "PTSContentLoader.h"

#pragma mark - Private Interface

@interface PTSContentLoader()

@property(nonatomic, strong) NSURL *URL;
@property(nonatomic, strong, readwrite) NSAttributedString *attributedString;
@property(nonatomic, strong, readwrite) NSString *plainString;

@end

#pragma mark - Implementation

@implementation PTSContentLoader

#pragma mark - Class Methods

/**
 *  contentLoaderWithFilename
 */
+ (instancetype)contentLoaderWithFilename:(NSString *)filename {
  NSString *extension = [filename pathExtension];
  NSString *resourceName = [filename stringByDeletingPathExtension];
  NSURL *fileURL = [[NSBundle mainBundle] URLForResource:resourceName withExtension:extension];

  return [[self alloc] initWithURL:fileURL];
}

/**
 *  contentLoaderWithURL
 */
+ (instancetype)contentLoaderWithURL:(NSURL *)URL {
  return [[self alloc] initWithURL:URL];
}

#pragma mark - Lifecycle

/**
 *  initWithURL
 */
- (instancetype)initWithURL:(NSURL *)URL {
  NSParameterAssert(URL);
  
  self = [super init];
  if (self) {
    _URL = URL;
    
    [self loadContentAsRichText];
  }
  
  return self;
}

#pragma mark - Private Methods

/**
 *  loadContentAsRichText
 */
- (void)loadContentAsRichText {
  self.plainString = nil;
  self.attributedString = nil;

  NSError *error;
  NSDictionary *documentAttributes;
  NSData *data = [NSData dataWithContentsOfURL:self.URL options:NSDataReadingUncached error:&error];

  if (!data) {
    return;
  }

  NSAttributedString *loadedAttributeString = [[NSAttributedString alloc] initWithData:data
                                                                               options:@{ NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType }
                                                                    documentAttributes:&documentAttributes
                                                                                 error:nil];
  
  NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:loadedAttributeString.string];
  NSRange range = NSMakeRange (0, loadedAttributeString.length);
  
  [loadedAttributeString enumerateAttributesInRange:range
                                         options:0
                                      usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attributes, NSRange range, BOOL * _Nonnull stop) {
                                        // NSLog (@"range: %@  attributes: %@", NSStringFromRange(range), attributes);
                                        
                                        NSMutableDictionary *mutableAttributes = [[NSMutableDictionary alloc] init];
                                        
                                        if (attributes[NSParagraphStyleAttributeName]) {
                                          mutableAttributes[NSParagraphStyleAttributeName] = attributes[NSParagraphStyleAttributeName];
                                        }
                                        
                                        if (attributes[NSLinkAttributeName]) {
                                          mutableAttributes[NSLinkAttributeName] = attributes[NSLinkAttributeName];
                                          mutableAttributes[@(UIAccessibilityTraitLink)] = @(YES);
                                        }
                                        
                                        // Hijack the double-underline attribute and interpret that to me that this paragraph is a heading.
                                        if ([attributes[NSUnderlineStyleAttributeName] integerValue] == 9) {
                                          mutableAttributes[@(UIAccessibilityTraitHeader)] = @(YES);
                                        }
                                        
                                        [mutableAttributedString addAttributes:[mutableAttributes copy] range:range];
                                      }];

  self.attributedString = [mutableAttributedString copy];
  self.plainString = loadedAttributeString.string;
}

@end
