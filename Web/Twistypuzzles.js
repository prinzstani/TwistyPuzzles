    // once everything is loaded, we run our Three.js stuff.
    function init() {
        // create a scene, that will hold all our elements such as objects, cameras and lights.
        let scene = new THREE.Scene();
        scene.background = new THREE.Color(0xffffff);
        // create a camera, which defines where we're looking at.
        let camera = new THREE.PerspectiveCamera(45, 200 / 200, 0.1, 1000);
        // create a render and set the size
        let renderer = new THREE.WebGLRenderer();
        renderer.setClearColor(new THREE.Color(0xeeeeee, 1.0));
        renderer.setSize(200, 200);
        renderer.shadowMapEnabled = false;
  
        shapes = [];

        createCube(new THREE.BoxGeometry(4, 4, 4), 0, 0, 0, scene, shapes, 4)
        createCube(new THREE.IcosahedronGeometry(4), 5, 5, 0, scene, shapes, 4)
        createCube(new THREE.DodecahedronGeometry(4), -5, -5, 0, scene, shapes, 4)
        createCube(new THREE.TetrahedronGeometry(4), -5, 5, 0, scene, shapes, 4)
        createCube(new THREE.OctahedronGeometry(4), 5, -5, 0, scene, shapes, 4)

        // position and point the camera to the center of the scene
        camera.position.x = -30;
        camera.position.y = 40;
        camera.position.z = 30;
        camera.lookAt(scene.position);
        // add subtle ambient lighting
        var ambientLight = new THREE.AmbientLight(0xffffff);
        scene.add(ambientLight);
        // add spotlight for the shadows
        /*var spotLight = new THREE.SpotLight(0xffffff);
          spotLight.position.set(-40, 60, -10);
          spotLight.castShadow = true;
          scene.add(spotLight);*/
        // add the output of the renderer to the html element
        document.getElementById("threeoutput").appendChild(renderer.domElement);
        // call the render function
        var step = 0;
        renderScene();
        function renderScene() {
          // rotate the cube around its axes
          for (shape of shapes) {
            shape.rotation.x += 0.01;
            shape.rotation.y += 0.02;
            if(Math.random()>0.99) {
                shape.scale.set(2, 2, 2)
            }
          }
          // render using requestAnimationFrame
          requestAnimationFrame(renderScene);
          renderer.render(scene, camera);
        }
      }
      window.onload = init;
  
      createCube = function (geometry, x, y, z, scene, shapes, size) {
                  // create a cube
//        let geometry = new THREE.BoxGeometry(size, size, size);
        for (let i = 0; i < geometry.faces.length; i++) {
          geometry.faces[i].color.set("black");
        }
        // The cube should have roughly 12 faces (6 sides with 2 triangles each)
        geometry.faces[0].color.set("red");
        geometry.faces[1].color.set("red");
        geometry.faces[2].color.set("blue");
//        geometry.faces[5].color.set("blue");
        geometry.faces[3].color.set("yellow");
//        geometry.faces[9].color.set("yellow");
  
        let material = new THREE.MeshBasicMaterial({
          color: 0xffffff,
          vertexColors: true,
        });
  
        let cube = new THREE.Mesh(geometry, material);
        cube.castShadow = true;
        // position the cube
        cube.position.x = x;
        cube.position.y = y;
        cube.position.z = z;
  
        //add wireframe
        let wireframeMaterial = new THREE.MeshBasicMaterial({
          color: 0x000000,
          wireframe: true,
          transparent: true,
        });
  
        let wireframe = new THREE.Mesh(geometry, wireframeMaterial);
        cube.add(wireframe);

        scene.add(cube);
        shapes.push(cube);
      }