
void A( void( *call )( void ) )
{

}

void C( int (*s)[10] )
{

}

void ( *complicated( int a , void( *f )( int ) ) ) ( int )
{
    void( *b )( int ) = NULL ;
    return b ;
}

float ( *GetPointer( int a ) )[10]
{
    ( void )a ;
    return NULL ;
}
