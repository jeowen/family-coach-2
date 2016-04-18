//
//  NSString+PTSString.m
//  PTSD Coach
//

#import "NSString+PTSString.h"

@implementation NSString (PTSString)

#pragma mark - Public Methods

/**
 *  pts_arrayBySplittingStringIntoParagraphs
 *
 *  See: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Strings/Articles/stringsParagraphBreaks.html
 *
 */
- (NSArray *)pts_arrayBySplittingStringIntoParagraphs {
  NSUInteger length = self.length;
  NSUInteger paragraphStart = 0;
  NSUInteger paragraphEnd = 0;
  NSUInteger contentsEnd = 0;
  NSRange currentRange;
  
  NSMutableArray *mutableParagraphs = [NSMutableArray array];
  
  while (paragraphEnd < length) {
    [self getParagraphStart:&paragraphStart
                        end:&paragraphEnd
                contentsEnd:&contentsEnd
                   forRange:NSMakeRange(paragraphEnd, 0)];
    
    currentRange = NSMakeRange(paragraphStart, contentsEnd - paragraphStart);
    
    // Only consider non-zero length paragraphs. In other words, a bunch of sequential
    // new lines or carriage returns in a document will not create new paragraphs.
    if (currentRange.length > 0) {
      id paragraph = [self substringWithRange:currentRange];
      
      if (paragraph) {
        [mutableParagraphs addObject:paragraph];
      }
    }
  }
  
  return [mutableParagraphs copy];
}

@end
