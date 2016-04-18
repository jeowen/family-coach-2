//
//  NSAttributedString+PTSAttributedString.m
//  PTSD Coach
//

#import "NSAttributedString+PTSAttributedString.h"

#pragma mark - Implementation

@implementation NSAttributedString (PTSAttributedString)

#pragma mark - Public Methods

/**
 *  pts_arrayBySplittingStringIntoAttributedParagraphs
 *
 *  See: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Strings/Articles/stringsParagraphBreaks.html
 *
 */
- (NSArray *)pts_arrayBySplittingStringIntoAttributedParagraphs {
  // Warning: NSAttributedString does not the method getParagraphStart. To "work around" that,
  // we use the NSString version of this attributed string to find the paragraphs and then
  // take those ranges and extract attributed substrings. This *appears* to work, at least
  // for our intended use-case, but I have no idea if there are situations where this would fail.
  
  NSString *plainString = self.string;
  NSUInteger length = plainString.length;
  NSUInteger paragraphStart = 0;
  NSUInteger paragraphEnd = 0;
  NSUInteger contentsEnd = 0;
  NSRange currentRange;
  
  NSMutableArray *mutableParagraphs = [NSMutableArray array];
  
  while (paragraphEnd < length) {
    [plainString getParagraphStart:&paragraphStart
                               end:&paragraphEnd
                       contentsEnd:&contentsEnd
                          forRange:NSMakeRange(paragraphEnd, 0)];
    
    currentRange = NSMakeRange(paragraphStart, contentsEnd - paragraphStart);

    // Only consider non-zero length paragraphs. In other words, a bunch of sequential
    // new lines or carriage returns in a document will not create new paragraphs.
    if (currentRange.length > 0) {
      NSAttributedString *attributedParagraph = [self attributedSubstringFromRange:currentRange];
      
      if (attributedParagraph) {
        [mutableParagraphs addObject:attributedParagraph];
      }
    }
  }
  
  return [mutableParagraphs copy];
}

@end
