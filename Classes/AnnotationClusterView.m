//
//  AnnotationClusterView.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/31/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "AnnotationClusterView.h"
#import "AnnotationCluster.h"

@implementation AnnotationClusterView

@synthesize clusterCount;

- (id)initWithAnnotation:(AnnotationCluster *)annotation reuseIdentifier:(NSString *)reuseIdentifier;
{
	if ((self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
		NSString *imageName = [NSString stringWithFormat:@"m%i.png", [annotation quintile]];
		self.image = [UIImage imageNamed:imageName];
		
		UILabel *label = [[UILabel alloc] init];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont systemFontOfSize:12.0]];
		self.clusterCount = label;
		[label release];
		
		CGSize size = self.frame.size;
		CGPoint center = self.center;
		
		self.clusterCount.frame = CGRectMake(center.x, center.y, size.width, size.height);
        self.backgroundColor = [UIColor clearColor];
		[self addSubview:clusterCount];
	}
	return self;
}

-(void) dealloc;
{
	[clusterCount release];	
	[super dealloc];
}

@end
