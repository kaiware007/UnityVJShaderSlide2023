using UnityEngine;
using System.Collections;
using KUtil;
using UnityEngine.Serialization;

public class ImageEffectManager : SingletonMonoBehaviour<ImageEffectManager>
{
    #region public
    public EdgeDetection edgeDetection;
    public RadiationBlur radiationBlur;
    public Distortion distortion;
    public AsciiArtEffect asciiArt;
    public FoldRotate foldRotate;
    public RGBShiftGlitch rgbShift;
    public CutOffColor cutOffColor;
    
    [SerializeField]
    KeyCode asciiArtKey = KeyCode.F1;
    [SerializeField]
    KeyCode foldRotateKey = KeyCode.F2;
    [SerializeField]
    KeyCode edgeDetectionKey = KeyCode.F5;
    [SerializeField]
    KeyCode radiationBlurKey = KeyCode.F6;
    [SerializeField]
    KeyCode cutOffColorKey = KeyCode.F7;
    [SerializeField]
    KeyCode cutOffColorInvertKey = KeyCode.F8;
    [SerializeField]
    KeyCode distortionKey = KeyCode.F9;
    [SerializeField]
    KeyCode rgbShiftKey = KeyCode.F10;

    public float effectTime = 0.25f;
    public float maxRadiationBlurPower = 32;
    public float maxGlitchIntensity = 0.9f;
    public float maxDistortionPower = 0.1f;
    public float maxRGBShiftPower = 16;
    #endregion

    bool isNegative = false;
    bool isEdgeDetect = false;

    public void ResetEffect()
    {
        isNegative = false;
        edgeDetection.enabled = true;
        edgeDetection.blend = 1;
        isEdgeDetect = false;
        radiationBlur.power = 0;
        distortion.enabled = true;
        distortion.power = 0;
        rgbShift.enabled = true;
        rgbShift.shiftPower = 0;

        asciiArt.enabled = false;
        foldRotate.enabled = false;
        cutOffColor.enabled = false;
    }
    
    IEnumerator ActionEdgeDetection()
    {
        float duration = effectTime;
        float start = isEdgeDetect ? 0 : 1;
        float end = 1f - start;
        isEdgeDetect = !isEdgeDetect;
        while (duration > 0f)
        {
            duration = Mathf.Max(duration - Time.deltaTime, 0);
            edgeDetection.blend = Easing.Ease(EaseType.QuadOut, start, end, 1f - duration / effectTime);
            yield return null;
        }
    }

    IEnumerator ActionRadiationBlur()
    {
        float duration = effectTime;
        while (duration > 0f)
        {
            duration = Mathf.Max(duration - Time.deltaTime, 0);
            radiationBlur.power = Easing.Ease(EaseType.QuadOut, maxRadiationBlurPower, 1, 1f - duration / effectTime);
            yield return null;
        }
    }
    
    IEnumerator ActionDistortion()
    {
        float duration = effectTime;
        while (duration > 0f)
        {
            duration = Mathf.Max(duration - Time.deltaTime, 0);
            distortion.power = Easing.Ease(EaseType.QuadOut, maxDistortionPower, 0, 1f - duration / effectTime);
            yield return null;
        }
    }

    void KeyCheck()
    {
        if (Input.GetKeyDown(asciiArtKey))
        {
            asciiArt.enabled = !asciiArt.enabled;
        }

        if (Input.GetKeyDown(foldRotateKey))
        {
            foldRotate.enabled = !foldRotate.enabled;
        }

        if (Input.GetKeyDown(edgeDetectionKey))
        {
            StartCoroutine(ActionEdgeDetection());
        }
        if (Input.GetKeyDown(radiationBlurKey))
        {
            StartCoroutine(ActionRadiationBlur());
        }
        if (Input.GetKeyDown(rgbShiftKey))
        {
            rgbShift.Beat();
        }
        if (Input.GetKeyDown(distortionKey))
        {
            StartCoroutine(ActionDistortion());
        }
        if (Input.GetKeyDown(cutOffColorKey))
        {
            cutOffColor.enabled = !cutOffColor.enabled;
        }

        if (Input.GetKeyDown(cutOffColorInvertKey))
        {
            cutOffColor.isReverse = !cutOffColor.isReverse;
        }
    }

    private void Start()
    {
        ResetEffect();
    }

    private void Update()
    {
        KeyCheck();
    }
}
