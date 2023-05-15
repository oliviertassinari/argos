import { useMutation } from "@apollo/client";

import { FragmentType, graphql, useFragment } from "@/gql";
import { BuildStatus, Permission, ValidationStatus } from "@/gql/graphql";
import { Button, ButtonArrow } from "@/ui/Button";
import {
  Menu,
  MenuButton,
  MenuItem,
  MenuItemIcon,
  useMenuState,
} from "@/ui/Menu";
import { MagicTooltip } from "@/ui/Tooltip";

import { getBuildIcon } from "./Build";

export const ProjectFragment = graphql(`
  fragment ReviewButton_Project on Project {
    name
    permissions
    public
    account {
      id
      slug
      consumptionRatio
      hasUsageBasedPlan
    }
    build(number: $buildNumber) {
      id
      status
    }
  }
`);

const SetValidationStatusMutation = graphql(`
  mutation setValidationStatus(
    $buildId: ID!
    $validationStatus: ValidationStatus!
  ) {
    setValidationStatus(
      buildId: $buildId
      validationStatus: $validationStatus
    ) {
      id
      status
    }
  }
`);

interface BaseReviewButtonProps {
  build: { id: string; status: BuildStatus };
  disabled?: boolean;
}

const BaseReviewButton = ({
  build,
  disabled = false,
}: BaseReviewButtonProps) => {
  const menu = useMenuState({ placement: "bottom-end", gutter: 4 });
  const [setValidationStatus, { loading }] = useMutation(
    SetValidationStatusMutation,
    {
      optimisticResponse: (variables) => ({
        setValidationStatus: {
          id: variables.buildId,
          status:
            variables.validationStatus === ValidationStatus.Accepted
              ? BuildStatus.Accepted
              : variables.validationStatus === ValidationStatus.Rejected
              ? BuildStatus.Rejected
              : BuildStatus.Pending,
        },
      }),
    }
  );

  const AcceptIcon = getBuildIcon("check", "accepted");
  const RejectIcon = getBuildIcon("check", "rejected");

  return (
    <>
      <MenuButton state={menu} as={Button} disabled={disabled || loading}>
        Review changes
        <ButtonArrow />
      </MenuButton>
      <Menu state={menu} aria-label="Review choices">
        <MenuItem
          state={menu}
          onClick={() => {
            setValidationStatus({
              variables: {
                buildId: build.id,
                validationStatus: ValidationStatus.Accepted,
              },
            });
            menu.hide();
          }}
          disabled={build.status === "accepted"}
        >
          <MenuItemIcon className="text-success-500">
            <AcceptIcon />
          </MenuItemIcon>
          Approve changes
        </MenuItem>
        <MenuItem
          state={menu}
          onClick={() => {
            setValidationStatus({
              variables: {
                buildId: build.id,
                validationStatus: ValidationStatus.Rejected,
              },
            });
            menu.hide();
          }}
          disabled={build.status === "rejected"}
        >
          <MenuItemIcon className="text-danger-500">
            <RejectIcon />
          </MenuItemIcon>
          Reject changes
        </MenuItem>
      </Menu>
    </>
  );
};

interface DisabledReviewButtonProps {
  build: BaseReviewButtonProps["build"];
  tooltip: React.ReactNode;
}

const DisabledReviewButton = ({
  build,
  tooltip,
}: DisabledReviewButtonProps) => {
  return (
    <MagicTooltip tooltip={tooltip} variant="info">
      <div className="flex">
        <BaseReviewButton build={build} disabled />
      </div>
    </MagicTooltip>
  );
};

export const ReviewButton = (props: {
  project: FragmentType<typeof ProjectFragment>;
}) => {
  const project = useFragment(ProjectFragment, props.project);
  if (
    !project.build ||
    !project.account ||
    !["accepted", "rejected", "diffDetected"].includes(project.build.status)
  ) {
    return null;
  }

  if (!project.permissions.includes("write" as Permission)) {
    return (
      <DisabledReviewButton
        build={project.build}
        tooltip={
          <>
            You must be part of <strong>{project.account.slug}</strong> team to
            review changes.
          </>
        }
      ></DisabledReviewButton>
    );
  }

  if (
    !project.public &&
    typeof project.account.consumptionRatio === "number" &&
    project.account.consumptionRatio >= 1 &&
    !project.account.hasUsageBasedPlan
  ) {
    return (
      <DisabledReviewButton
        build={project.build}
        tooltip={
          <>
            You have hit {Math.floor(project.account.consumptionRatio * 100)}%
            of your current plan. Please upgrade to unlock build reviews.
          </>
        }
      />
    );
  }

  return <BaseReviewButton build={project.build} />;
};
