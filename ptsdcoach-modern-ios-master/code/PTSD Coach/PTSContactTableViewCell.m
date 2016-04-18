//
//  PTSContactTableViewCell.m
//  PTSD Coach
//

@import Contacts;
#import "PTSContactTableViewCell.h"

#pragma mark - Implementation

@implementation PTSContactTableViewCell

#pragma mark - Public Methods

/**
 *  prepareWithContact
 */
- (void)prepareWithContact:(CNContact *)contact {
  NSParameterAssert(contact != nil);
  
  self.primaryText = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
}

@end
