﻿using UnityEngine;
using UnityEditor;

public class ToonLegacyUberShaderGUI : ShaderGUI
{
    MaterialProperty color;
    MaterialProperty mainTex;
    MaterialProperty specularEnabled;
    MaterialProperty specColor;
    MaterialProperty shininess;
    MaterialProperty normalMapEnabled;
    MaterialProperty bumpMap;
    MaterialProperty reflectionEnabled;
    MaterialProperty reflectColor;
    MaterialProperty cube;
    MaterialProperty emissionEnabled;
    MaterialProperty illum;
    MaterialProperty emission;
    MaterialProperty decalEnabled;
    MaterialProperty decalTex;
    MaterialProperty parallaxEnabled;
    MaterialProperty parallax;
    MaterialProperty parallaxMap;

    static readonly GUIContent colorText = new GUIContent("Main Color","");
    static readonly GUIContent mainTexText = new GUIContent("Base (RGB) Gloss (A)","");
    static readonly GUIContent specularEnabledText = new GUIContent("Specular?","");
    static readonly GUIContent specColorText = new GUIContent("Specular Color","");
    static readonly GUIContent shininessText = new GUIContent("Shininess","");
    static readonly GUIContent normalMapEnabledText = new GUIContent("Normal Map?","");
    static readonly GUIContent bumpMapText = new GUIContent("Normal Map","");
    static readonly GUIContent reflectionEnabledText = new GUIContent("Reflection?","");
    static readonly GUIContent reflectColorText = new GUIContent("Reflection Color","");
    static readonly GUIContent cubeText = new GUIContent("Reflection Cubemap","");
    static readonly GUIContent emissionEnabledText = new GUIContent("Emission?","");
    static readonly GUIContent illumText = new GUIContent("Illumin (A)","");
    static readonly GUIContent emissionText = new GUIContent("Emission (Lightmapper)","");
    static readonly GUIContent decalEnabledText = new GUIContent("Decal?","");
    static readonly GUIContent decalTexText = new GUIContent("Decal (RGBA)","");
    static readonly GUIContent parallaxEnabledText = new GUIContent("Parallax?","");
    static readonly GUIContent parallaxText = new GUIContent("Height","");
    static readonly GUIContent parallaxMapText = new GUIContent("Height Map (A)","");

    public void FindProperties(MaterialProperty[] props)
    {
        color = FindProperty("_Color", props);
        mainTex = FindProperty("_MainTex", props);
        specularEnabled = FindProperty("_SpecularEnabled", props);
        specColor = FindProperty("_SpecColor", props);
        shininess = FindProperty("_Shininess", props);
        normalMapEnabled = FindProperty("_NormalMapEnabled", props);
        bumpMap = FindProperty("_BumpMap", props);
        reflectionEnabled = FindProperty("_ReflectionEnabled", props);
        reflectColor = FindProperty("_ReflectColor", props);
        cube = FindProperty("_Cube", props);
        emissionEnabled = FindProperty("_EmissionEnabled", props);
        illum = FindProperty("_Illum", props);
        emission = FindProperty("_Emission", props);
        decalEnabled = FindProperty("_DecalEnabled", props);
        decalTex = FindProperty("_DecalTex", props);
        parallaxEnabled = FindProperty("_ParallaxEnabled", props);
        parallax = FindProperty("_Parallax", props);
        parallaxMap = FindProperty("_ParallaxMap", props);
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        FindProperties(props);

        Material targetMat = materialEditor.target as Material;

        materialEditor.ShaderProperty(color, colorText);
        materialEditor.ShaderProperty(mainTex, mainTexText);
        materialEditor.ShaderProperty(specularEnabled, specularEnabledText);
        if (specularEnabled.floatValue >= 1.0f) {
            materialEditor.ShaderProperty(specColor, specColorText);
            materialEditor.ShaderProperty(shininess, shininessText);
        }
        materialEditor.ShaderProperty(normalMapEnabled, normalMapEnabledText);
        if (normalMapEnabled.floatValue >= 1.0f) {
            materialEditor.ShaderProperty(bumpMap, bumpMapText);
        }
        materialEditor.ShaderProperty(reflectionEnabled, reflectionEnabledText);
        if (reflectionEnabled.floatValue >= 1.0f) {
            materialEditor.ShaderProperty(reflectColor, reflectColorText);
            materialEditor.ShaderProperty(cube, cubeText);
        }
        materialEditor.ShaderProperty(emissionEnabled, emissionEnabledText);
        if (emissionEnabled.floatValue >= 1.0f) {
            materialEditor.ShaderProperty(illum, illumText);
            materialEditor.ShaderProperty(emission, emissionText);
        }
        materialEditor.ShaderProperty(decalEnabled, decalEnabledText);
        if (decalEnabled.floatValue >= 1.0f) {
            materialEditor.ShaderProperty(decalTex, decalTexText);
        }
        materialEditor.ShaderProperty(parallaxEnabled, parallaxEnabledText);
        if (parallaxEnabled.floatValue >= 1.0f) {
            materialEditor.ShaderProperty(parallax, parallaxText);
            materialEditor.ShaderProperty(parallaxMap, parallaxMapText);
        }
    }
}