#define PI 3.14159
#define PI2 6.28318
#define RECIPROCAL_PI 0.31830988618
#define RECIPROCAL_PI2 0.15915494
#define LOG2 1.442695
#define EPSILON 1e-6

#define saturate(a) clamp( a, 0.0, 1.0 )
#define whiteCompliment(a) ( 1.0 - saturate( a ) )

float square( const in float x ) { return x*x; }
float average( const in vec3 color ) { return dot( color, vec3( 0.3333 ) ); }


struct IncidentLight {
	vec3 color;
	vec3 direction;
};

struct ReflectedLight {
	vec3 directDiffuse;
	vec3 directSpecular;
	vec3 indirectDiffuse;
	vec3 indirectSpecular;
};

struct GeometricContext {
	vec3 position;
	vec3 normal;
	vec3 viewDir;
};


vec3 transformDirection( in vec3 normal, in mat4 matrix ) {

	return normalize( ( matrix * vec4( normal, 0.0 ) ).xyz );

}

// http://en.wikibooks.org/wiki/GLSL_Programming/Applying_Matrix_Transformations
vec3 inverseTransformDirection( in vec3 normal, in mat4 matrix ) {

	return normalize( ( vec4( normal, 0.0 ) * matrix ).xyz );

}

vec3 projectOnPlane(in vec3 point, in vec3 pointOnPlane, in vec3 planeNormal ) {

	float distance = dot( planeNormal, point - pointOnPlane );

	return - distance * planeNormal + point;

}

float sideOfPlane( in vec3 point, in vec3 pointOnPlane, in vec3 planeNormal ) {

	return sign( dot( point - pointOnPlane, planeNormal ) );

}

vec3 linePlaneIntersect( in vec3 pointOnLine, in vec3 lineDirection, in vec3 pointOnPlane, in vec3 planeNormal ) {

	return lineDirection * ( dot( planeNormal, pointOnPlane - pointOnLine ) / dot( planeNormal, lineDirection ) ) + pointOnLine;

}

vec3 inputToLinear( in vec3 a ) {

	#ifdef GAMMA_INPUT

		return pow( a, vec3( float( GAMMA_FACTOR ) ) );

	#else

		return a;

	#endif

}

vec3 linearToOutput( in vec3 a ) {

	#ifdef GAMMA_OUTPUT

		return pow( a, vec3( 1.0 / float( GAMMA_FACTOR ) ) );

	#else

		return a;

	#endif

}

// http://stackoverflow.com/a/24390149 modified to work on a CubeMap.
float textureQueryLod( const in vec3 sampleDirection, const in float cubeMapWidth )
{
    vec3  dx_vtc        = dFdx( sampleDirection * cubeMapWidth );
    vec3  dy_vtc        = dFdy( sampleDirection * cubeMapWidth );
    float delta_max_sqr = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
    return 0.5 * log2( delta_max_sqr );
}
