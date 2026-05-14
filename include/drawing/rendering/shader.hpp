#pragma once
#include "drawing/rendering/primitives.hpp"
#include "tools/config_default.hpp"


enum ShaderType{
    SHADER_NONE,
    SHADER_RAINBOW,
    SHADER_FIRE,
};

class ShaderProcessor{
    private:
        static void ShaderNone(int16_t &x, int16_t &y, uint8_t &r, uint8_t &g, uint8_t &b, ShaderType &shdr, float &shaderStrenght);
        static void ShaderRainbow(int16_t &x, int16_t &y, uint8_t &r, uint8_t &g, uint8_t &b, ShaderType &shdr, float &shaderStrenght);
        static void ShaderFire(int16_t &x, int16_t &y, uint8_t &r, uint8_t &g, uint8_t &b, ShaderType &shdr, float &shaderStrength);


        static void Hsv2Rgb(uint8_t h, uint8_t s, uint8_t v, uint8_t& r, uint8_t& g, uint8_t& b);

        static uint32_t FrameId;
        static uint32_t Time;
    public:
        static void UpdateColorByShader(int16_t &x, int16_t &y, uint8_t &r, uint8_t &g, uint8_t &b, ShaderType &shdr, float &shaderStrenght);
        static void IncrFrame();
};