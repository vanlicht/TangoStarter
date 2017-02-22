using System;
using System.Collections;
using UnityEngine;

public class AnimalUIController : MonoBehaviour
{
    public GameObject animal;
    private TangoPointCloud m_PointCloud;

	// Use this for initialization
	void Start ()
    {
        m_PointCloud = FindObjectOfType<TangoPointCloud>();

    }
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.touchCount == 1)
        {
            Touch t = Input.GetTouch(0);
            if(t.phase == TouchPhase.Ended)
            {
                PlaceAnimal(t.position);
            }
        }
	}

    private void PlaceAnimal(Vector2 touchPosition)
    {
        Camera cam = Camera.main;
        Vector3 planeCenter;
        Plane plane;
        if(!m_PointCloud.FindPlane(cam, touchPosition, out planeCenter, out plane))
        {
            Debug.Log("No plane found.");
            return;
        }

        // Place kitten on the surface, and make it always face the camera.
        //check if the plane normal is similar to up normal
        if(Vector3.Angle(plane.normal,Vector3.up) < 30f)
        {
            //if so, set the new up normal as the plane's normal
            Vector3 up = plane.normal;

            //set the right normal
            Vector3 right = Vector3.Cross(plane.normal, cam.transform.forward).normalized;
            Vector3 forward = Vector3.Cross(right, up).normalized;
            Instantiate(animal, planeCenter, Quaternion.LookRotation(forward, up));
        }
        else
        {
            Debug.Log("Surface is too steep for animal to stand on.");
        }
    }
}
