using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KittyUIController : MonoBehaviour
{
    public GameObject m_kitten;
    private TangoPointCloud m_pointCloud;

	void Start ()
    {
        m_pointCloud = FindObjectOfType<TangoPointCloud>();
	}
	
	void Update ()
    {
		if(Input.touchCount == 1)
        {
            //Trigger place kitten function when single touch ended
            Touch t = Input.GetTouch(0);
            if(t.phase == TouchPhase.Ended)
            {
                PlaceKitten(t.position);
            }
        }
	}

    private void PlaceKitten(Vector2 touchPosition)
    {
        // Find the plane
        Camera cam = Camera.main;
        Vector3 planeCenter;
        Plane plane;
        if(!m_pointCloud.FindPlane(cam, touchPosition, out planeCenter, out plane))
        {
            Debug.Log("Connot find plane");
            return;
        }
        //Place kitten on the surface, and make it always face the camera
        if(Vector3.Angle(plane.normal, Vector3.up) < 30f)
        {
            Vector3 up = plane.normal;
            Vector3 right = Vector3.Cross(plane.normal, cam.transform.forward).normalized;
            Vector3 forward = Vector3.Cross(right, plane.normal).normalized;
            Instantiate(m_kitten, planeCenter, Quaternion.LookRotation(forward, up));
        }
        else
        {
            Debug.Log("Surface is too stpeep for kitten to stand on");
        }
    }
}
