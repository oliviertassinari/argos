import { Helmet } from "react-helmet";
import {
  Navigate,
  Outlet,
  RouterProvider,
  createBrowserRouter,
} from "react-router-dom";

import { Layout, Main } from "@/containers/Layout";

import { ApolloInitializer } from "./containers/Apollo";
import { AuthProvider } from "./containers/Auth";
import { Account } from "./pages/Account";
import { AccountNewProject } from "./pages/Account/NewProject";
import { AccountProjects } from "./pages/Account/Projects";
import { AccountSettings } from "./pages/Account/Settings";
import { AuthCallback } from "./pages/AuthCallback";
import { Build } from "./pages/Build";
import { Home } from "./pages/Home";
import { Invite } from "./pages/Invite";
import { Login } from "./pages/Login";
import { NewTeam } from "./pages/NewTeam";
import { NotFound } from "./pages/NotFound";
import { Project } from "./pages/Project";
import { ProjectBuilds } from "./pages/Project/Builds";
import { ProjectReference } from "./pages/Project/Reference";
import { ProjectSettings } from "./pages/Project/Settings";
// import { Tests } from "./pages/Project/Tests";
import { Signup } from "./pages/Signup";
import { VercelCallback } from "./pages/Vercel";

const router = createBrowserRouter([
  {
    path: "/auth/github/callback",
    element: <AuthCallback />,
  },
  {
    path: "/vercel/callback",
    element: <VercelCallback />,
  },
  {
    path: "/:accountSlug/:projectName/builds/:buildNumber",
    element: <Build />,
  },
  {
    path: "/:accountSlug/:projectName/builds/:buildNumber/:diffId",
    element: <Build />,
  },
  {
    path: "/",
    element: (
      <Layout>
        <Outlet />
      </Layout>
    ),
    children: [
      {
        index: true,
        element: <Home />,
      },
      {
        path: "login",
        element: <Login />,
      },
      {
        path: "signup",
        element: <Signup />,
      },
      {
        path: "invite/:inviteToken",
        element: <Invite />,
      },
      {
        path: "teams/new",
        element: (
          <>
            <hr className="border-t-border" />
            <Main>
              <NewTeam />
            </Main>
          </>
        ),
      },
      {
        path: ":accountSlug/:projectName",
        element: <Project />,
        children: [
          {
            index: true,
            element: <ProjectBuilds />,
          },
          {
            path: "reference",
            element: <ProjectReference />,
          },
          {
            path: "builds",
            element: <Navigate to=".." replace={true} />,
          },
          {
            path: "settings",
            element: <ProjectSettings />,
          },
        ],
      },
      {
        id: "account",
        path: ":accountSlug",
        element: <Account />,
        children: [
          {
            index: true,
            element: <AccountProjects />,
          },
          {
            path: "new",
            element: <AccountNewProject />,
          },
          {
            path: "settings",
            element: <AccountSettings />,
          },
        ],
      },
      {
        path: "*",
        element: <NotFound />,
      },
    ],
  },
]);

export const App = () => {
  return (
    <>
      <Helmet defaultTitle="Argos" />
      <AuthProvider>
        <ApolloInitializer>
          <RouterProvider router={router} />
        </ApolloInitializer>
      </AuthProvider>
    </>
  );
};
