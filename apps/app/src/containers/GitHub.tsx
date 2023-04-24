import { MarkGithubIcon } from "@primer/octicons-react";
import { memo } from "react";
import { useLocation } from "react-router-dom";

import config from "@/config";
import { Button, ButtonIcon, ButtonProps } from "@/ui/Button";

const useLoginUrl = (redirect: string | null | undefined) => {
  const { origin } = window.location;
  const { pathname } = useLocation();
  return `${config.get(
    "github.loginUrl"
  )}&redirect_uri=${origin}/auth/github/callback?r=${encodeURIComponent(
    redirect ?? pathname
  )}`;
};

export type GitHubLoginButtonProps = Omit<ButtonProps, "children"> & {
  children?: React.ReactNode;
  redirect?: string | null;
};

export const GitHubLoginButton = memo<GitHubLoginButtonProps>(
  ({ children, redirect, ...props }) => {
    const loginUrl = useLoginUrl(redirect);
    return (
      <Button color="neutral" {...props}>
        {(buttonProps) => (
          <a href={loginUrl} {...buttonProps}>
            <ButtonIcon>
              <MarkGithubIcon />
            </ButtonIcon>
            {children ?? "Login"}
          </a>
        )}
      </Button>
    );
  }
);
