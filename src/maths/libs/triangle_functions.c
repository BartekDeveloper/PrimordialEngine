#include <math.h>
#include <float.h>
#include "sin.h" 
#include "cos.h" 
#include "tan.h" 

const double PI = 3.14159265358979323846;
const int TABLE_SIZE = 4096;

float MapAngleToTableIndex(float angle) {
   
    const float TABLE_ANGLE_RANGE = 4.0f * PI;
    const float TABLE_START_ANGLE = -2.0f * PI;

    float normalized_angle = fmodf(angle, TABLE_ANGLE_RANGE);
    if (normalized_angle < TABLE_START_ANGLE) {
        normalized_angle += TABLE_ANGLE_RANGE;
    } else if (normalized_angle >= (TABLE_START_ANGLE + TABLE_ANGLE_RANGE)) {
        normalized_angle -= TABLE_ANGLE_RANGE;
    }

    float ratio = (normalized_angle - TABLE_START_ANGLE) / TABLE_ANGLE_RANGE;
    int index = (int)(ratio * TABLE_SIZE);
    if (index < 0) {
        index = 0;
    } else if (index >= TABLE_SIZE) {
        index = TABLE_SIZE - 1;
    }
    return index;
}

// Sin table declaration (assuming filled by header)
extern const float SinTable[4096];

// Approximation of sin(x) using a lookup table
float SinApprox(float x) {
    int index = MapAngleToTableIndex(x);
    return SinTable[index];
}

// Approximation of sin(x) (casted to INT) using a lookup table
int SinI_Approx(float x) {
    return (int)(SinApprox(x) * 1024.0f);
}

double SinD_Approx(double x) {
    return (double)SinApprox((float)x);
}

// Find Approx or calculate sin(x) using buildin sin function
float Sin(float x) {
   
    if (x < -PI || x > PI) {
        return SinApprox(x);
    } else {
        return sinf(x);
    }
}

// Find Approx INT or calculate sin(x) (and cast to INT) using buildin sin function
int SinI(float x) {
    if (x < -PI || x > PI) {
        return (int)(SinApprox(x) * 1024.0f);
    } else {
        return (int)(sinf(x) * 1024.0f);
    }
}

// Find Approx or calculate sin(x) (and cast to INT) using buildin sin function
double SinD(double x) {
    if (x < -PI || x > PI) {
        return SinD_Approx(x);
    } else {
        return sin(x);
    }
}

// Cosine Table declaration (assuming filled by header)
extern const float CosTable[4096];

float CosApprox(float x) {
    int index = MapAngleToTableIndex(x);
    return CosTable[index];
}

int CosI_Approx(float x) {
    return (int)(CosApprox(x) * 1024.0f);
}

double CosD_Approx(double x) {
    return (double)CosApprox((float)x);
}

float Cos(float x) {
    if (x >= -PI && x <= PI) {
        return cosf(x);
    } else {
        return CosApprox(x);
    }
}

int CosI(float x) {
    if (x >= -PI && x <= PI) {
        return (int)(cosf(x) * 1024.0f);
    } else {
        return (int)(CosApprox(x) * 1024.0f);
    }
}

double CosD(double x) {
    if (x >= -PI && x <= PI) {
        return cos(x);
    } else {
        return CosD_Approx(x);
    }
}

// Tangent Table declaration (assuming filled by header)
extern const float TanTable[4096];

float TanApprox(float x) {
    int index = MapAngleToTableIndex(x);
    return TanTable[index];
}

int TanI_Approx(float x) {
    return (int)(TanApprox(x) * 1024.0f);
}

double TanD_Approx(double x) {
    return (double)TanApprox((float)x);
}

float Tan(float x) {
    if (x >= -PI && x <= PI) {
        return tanf(x);
    } else {
        return TanApprox(x);
    }
}

int TanI(float x) {
    if (x >= -PI && x <= PI) {
        return (int)(tanf(x) * 1024.0f);
    } else {
        return (int)(TanApprox(x) * 1024.0f);
    }
}

double TanD(double x) {
    if (x >= -PI && x <= PI) {
        return tan(x);
    } else {
        return TanD_Approx(x);
    }
}
