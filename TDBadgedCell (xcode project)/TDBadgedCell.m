//
//  TDBadgedCell.m
//  TDBadgedTableCell
//	TDBageView
//
//	Any rereleasing of this code is prohibited.
//	Please attribute use of this code within your application
//
//	Any Queries should be directed to hi@tmdvs.me | http://www.tmdvs.me
//	
//  Created by Tim on [Dec 30].
//  Copyright 2009 Tim Davies. All rights reserved.
//

#import "TDBadgedCell.h"

@implementation TDBadgeView

@synthesize width, badgeNumber, parent;

- (id) initWithNumber:(int)n
{
	badgeNumber = n;
	
	[self initWithFrame:CGRectZero];
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	
	countString = [NSString stringWithFormat: @"%d", badgeNumber];
	[countString retain];
	font = [UIFont boldSystemFontOfSize: 14];
	[font retain];
	numberSize = [countString sizeWithFont: font];
	
	width = numberSize.width + 16;
	
	if(self.parent.accessoryType)
	{
		frame = CGRectMake(320 - width - 8, 12,  width, 18);
	}
	else
	{
		frame = CGRectMake(320 - width - 28, 13,  width, 18);
	}

	
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor clearColor];
    }
	if(self.badgeNumber > 0)
	{
		if (self.hidden) 
		{
			return nil;
		}
		
		return self;
	}
	else
	{
		return nil;
	}
}

- (void) drawRect:(CGRect)rect
{
	
	width = numberSize.width + 16;
	
	CGRect bounds = CGRectMake(0 , 0, numberSize.width + 16 , 18);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	float radius = bounds.size.height / 2.0;
	
	CGContextSaveGState(context);
	//CGContextClearRect(context, bounds);
	if(parent.selected)
	{
		CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000] CGColor]);
	}
	else
	{
		CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000] CGColor]);
	}
		
	CGContextBeginPath(context);
	CGContextAddArc(context, radius, radius, radius, M_PI / 2 , 3 * M_PI / 2, NO);
	CGContextAddArc(context, bounds.size.width - radius, radius, radius, 3 * M_PI / 2, M_PI / 2, NO);
	CGContextClosePath(context);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	if(parent.selected)
	{
		[[UIColor blueColor] set];
	}
	else
	{
		[[UIColor whiteColor] set];
	}
	
	bounds.origin.x = (bounds.size.width - numberSize.width) / 2 +0.5;
	
	[countString drawInRect: bounds withFont: font];
	
}

- (void) dealloc
{
	[super dealloc];
	[font release];
	[countString release];
}
	 

@end


@implementation TDBadgedCell

@synthesize badgeNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
	if(self.badgeNumber > 0)
	{
		badge = [[TDBadgeView alloc] initWithNumber:self.badgeNumber];
		[badge setParent:self];
		if(self.accessoryType)
		{
			[self addSubview:badge];
			[badge setNeedsDisplay];
		}
		else
		{
			[self setAccessoryView:badge];
		}
		
		if(self.editing)
		{
			badge.hidden = YES;
			[badge setNeedsDisplay];
		}
		
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[badge setNeedsDisplay];
    [super setSelected:selected animated:animated];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	if (editing) {
		badge.hidden = YES;
		[badge setNeedsDisplay];
	}
	else 
	{
		badge.hidden = NO;
		[badge setNeedsDisplay];
	}

}


- (void)dealloc {
    [super dealloc];
}


@end
