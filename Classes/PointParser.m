//
//  PointParser.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/19/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "PointParser.h"
#import "CommonMacros.h"
#import "TBXML.h"

#import "FormaPoint.h"

@implementation PointParser

-(id) init;
{
	if ((self = [super init])) {
		[self loadPoints];
	}
    return self;
}

- (void)loadPoints;
{
	NSMutableArray *formaPoints = [[NSMutableArray alloc] initWithCapacity:200];
	
	// Load and parse the books.xml file
	TBXML *tbxml = [[TBXML alloc] initWithXMLFile:@"formapoints.xml"];
	
	TBXMLElement *root = tbxml.rootXMLElement;
	
	if (root) {
		TBXMLElement *point = [TBXML childElementNamed:@"point" parentElement:root];
		
		// if an author element was found
		while (!IsEmpty(point)) {
			
			// instantiate an author object
			FormaPoint *formaPoint = [[FormaPoint alloc] init];
			
			// get the name attribute from the author element
			formaPoint.name = [TBXML valueOfAttributeNamed:@"name" forElement:author];
			
			// search the author's child elements for a book element
			TBXMLElement * book = [TBXML childElementNamed:@"description" parentElement:author];
			
			// if a book element was found
			while (book != nil) {
				
				// instantiate a book object
				Book * aBook = [[Book alloc] init];
				
				// extract the title attribute from the book element
				aBook.title = [TBXML valueOfAttributeNamed:@"title" forElement:book];
				
				// extract the title attribute from the book element
				NSString * price = [TBXML valueOfAttributeNamed:@"price" forElement:book];
				
				// if we found a price
				if (price != nil) {
					// obtain the price from the book element
					aBook.price = [NSNumber numberWithFloat:[price floatValue]];
				}
				
				// find the description child element of the book element
				TBXMLElement * desc = [TBXML childElementNamed:@"description" parentElement:book];
				
				// if we found a description
				if (desc != nil) {
					// obtain the text from the description element
					aBook.description = [TBXML textForElement:desc];
				}
				
				// add the book object to the author's books array and release the resource
				[anAuthor.books addObject:aBook];
				[aBook release];
				
				// find the next sibling element named "book"
				book = [TBXML nextSiblingNamed:@"book" searchFromElement:book];
			}
			
			// add our author object to the authors array and release the resource
			[authors addObject:anAuthor];
			[anAuthor release];
			
			// find the next sibling element named "author"
			author = [TBXML nextSiblingNamed:@"author" searchFromElement:author];
		}			
	}
	
	// release resources
	[tbxml release];
}


@end
