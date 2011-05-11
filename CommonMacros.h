
/*
 
 Common Macros, plus a few keys.
 
 */

#define kTileCacheName @"MapTileCache"

#define TILE_SIZE 256.0
#define kMaxFormaZoomLevel 7

#ifndef __IPHONE_3_2	// if iPhoneOS is 3.2 or greater then __IPHONE_3_2 will be defined

typedef enum {
    UIUserInterfaceIdiomPhone,           // iPhone and iPod touch style UI
    UIUserInterfaceIdiomPad,             // iPad style UI
} UIUserInterfaceIdiom;

#define UI_USER_INTERFACE_IDIOM() UIUserInterfaceIdiomPhone

#endif // ifndef __IPHONE_3_2

static inline BOOL IsIPad()
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

//Thanks to Wil Shipley for the code below.
//http://wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html

static inline BOOL IsEmpty(id thing)
{
    return thing == nil
    || ([thing isEqual:[NSNull null]]) //JS addition for coredata
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}
